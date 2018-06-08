require 'rubygems'
require 'nokogiri'
require 'mechanize'
require "active_record"
require "ruby-debug"

ActiveRecord::Base.establish_connection(:adapter => 'mysql',:host => '192.168.1.4',
                                        :username => 'root',:password => 'pingco82600011',:database => 'dcs_production',:encoding => "utf8")
class Tasks < ActiveRecord::Base
  set_table_name :tasks
end

class PaChong


  def initialize
    @agent = Mechanize.new
    @agent.user_agent_alias = 'Mac Safari'
    @agent.request_headers = {'Accept-Language' => "zh-cn,zh;q=0.5"}
    @agent.max_history = 1
    @task = Tasks.find(115)
  end

  def get_page(url)
    @agent.get(url)
  end

  def get_html(url)
    page = get_page(url)
    Iconv.iconv('UTF-8', 'GB18030', page.body).first rescue nil
  end

  def get_document(url)
    html_str = get_html(url)
    return nil if html_str.nil?
    html_doc = Nokogiri::HTML::Document.parse(html_str, nil, 'UTF-8') rescue nil
    html_doc
  end

  def get_content
    @document = get_document("http://zhibo365.org/NBA-top10/76112.html")
    str = @document.css('.video_txt').to_s.gsub(/(src|href)="(.*?)"/) do |replacement|
      frag1, frag2 = $1, $2
      puts "replacement is :#{replacement}"
      if replacement =~ /http|https/
        replacement
      elsif replacement =~ /#{frag1}="\/.*/
        root_uri = URI.parse(@original_page.url)
        domain_url = root_uri.scheme + '://' + root_uri.host
        "#{frag1}=\"#{domain_url}#{frag2}\""
      else
        root_directory = @original_page.url.gsub(/(.+:\/\/.*)(\/.+)*(\/.*)$/, '\1\2')
        "#{frag1}=\"#{root_directory}/#{frag2}\""
      end
    end
     puts str
  end


  def url_reg_parse
    html = get_html("http://zhibo365.org/NBA-top10/76112.html")
    root_uri = URI.parse(@task.root_url)
    domain_url = root_uri.scheme + '://' + root_uri.host
    root_directory = @task.root_url.gsub(/(.+:\/\/.*)(\/.+)*(\/.*)$/, '\1\2')
    urls = html.scan(/#{@task.url_regexp}/).flatten
    urls.map do |url|
      if url =~ /http|https/
        url
      elsif url =~ /^\/.*/
        "#{domain_url}#{url}"
      else
        "#{root_directory}/#{url}"
      end
    end
  end


end
PaChong.new.url_reg_parse