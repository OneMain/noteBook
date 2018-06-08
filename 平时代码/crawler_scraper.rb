# encoding:utf-8
require "rubygems"
require 'mechanize'
require 'nokogiri'
require 'active_record'
require 'json'


class Jd_spider_engine
  def run
    #Mechanize::Util::CODE_DIC[:SJIS] = "utf-8"
    agent = Mechanize.new
    agent.user_agent_alias = 'Mac Safari'
    agent.max_history = 1
    agent.open_timeout = 10

    page = agent.get("http://list.jd.com/670-671-672-0-0-0-0-0-0-0-1-1-1-1-1-72-4137-0.html",nil,nil,{ 'Accept-Charset' => 'utf-8' }
    )

    #测试中文
    page.search("div.iloading").children.each { |c|
      #puts c.to_s.force_encoding("utf-8")
       puts c
    }

    #body内容
    puts page.body
  end
end

jd_spider_engine = Jd_spider_engine.new
jd_spider_engine.run
