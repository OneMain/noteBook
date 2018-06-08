require 'rubygems'
require 'nokogiri'
require 'mechanize'
require 'active_record'

ActiveRecord::Base.establish_connection(:adapter => 'mysql',:encoding => 'utf8',
  :host=> '192.168.1.4',:username => 'root',:password => "pingco82600011",:database => 'test')
class Lottery < ActiveRecord::Base
  set_table_name "lottery"
  def creat_lottery(term,&block)
    lottery = Lottery.find_or_create_by_term_no(term)
    items = block.call
    lottery.update_attributes(items)
  end
end
class PaChong
  def zhuqu
    @agent = Mechanize.new
    @agent.user_agent_alias = 'Mac Safari'
    doc =  @agent.get("http://www.cwl.gov.cn/")
    team_html = Iconv.iconv('UTF-8', 'utf-8', doc.body).first
    shaungse_html = Nokogiri::HTML::Document.parse(team_html,nil,'UTF-8')
    caizhong = shaungse_html.css(".lay_left_top > ul.kaij.kaij_double li.caizhong span")
    haoma_div = shaungse_html.css(".lay_left_top > ul.kaij.kaij_double li.haoma span")

    qius= []
    term_no =  caizhong.css("span")[0].text
    haoma_div.css("span").each do |qiu|
      qius.push(qiu.text)
    end
    puts qius.class
    Lottery.new.creat_lottery(term_no) do
      {:lottery_time => caizhong.css("span")[1].text.split("：")[1].strip(),:prize_pool_amount => caizhong.css("span")[3].text.split("：")[1].strip(),
       :sales_volume => caizhong.css("span")[2].text.split("：")[1].strip(),:red_num => qius[0,6].join(","),:blue_num => qius[-1]
      }
    end
  end
end
PaChong.new.zhuqu
