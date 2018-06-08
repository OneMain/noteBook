require "rubygems"
require "mechanize"
require "nokogiri"
require "active_record"

ActiveRecord::Base.establish_connection(:adapter => 'mysql',:host => '192.168.1.4',
  :username => 'root',:password => 'pingco82600011',:database => 'test',:encoding => "utf8")
class SysConfig < ActiveRecord::Base
  set_table_name :sys_config

  def create_sysinfo(code,&block)
    @config_info = SysConfig.find_or_create_by_code(code)
    items = block.call
    @config_info.update_attributes(items)
  end

end

class PaChong
  def zhuaqu
    sys_config_desc = []

    @agent = Mechanize.new
    @agent.user_agent_alias = 'Mac Safari'
    doc = @agent.get("http://www.cwl.gov.cn/")
    luntus  = Iconv.iconv("utf-8","utf-8",doc.body).first
    luntus_parse = Nokogiri::HTML::Document.parse(luntus,nil,"UTF-8")
    images_and_hrefs = luntus_parse.css("#change_23 > div.changeDiv")
    images_and_hrefs.each do |inner_html|
    images =
    link_url = inner_html.at("a").get_attribute("href")
    desc =%Q("unlinked" =#{link_url.index(/http|https/).nil?} ,"link_url" =#{link_url.index(/http|https/).nil? ? "" : link_url },
    "img_url" = #{inner_html.at("img").get_attribute("src")}, "title" = #{inner_html.at("a").text})
    sys_config_desc.push(desc)
    end
    SysConfig.new.create_sysinfo("HOME_ADS") do
      {:name => '首页轮回图',:desc => sys_config_desc.join("#"),:is_valid => 1,:created_at => Time.now(),:updated_at => Time.now()}
    end
  end

end
PaChong.new.zhuaqu