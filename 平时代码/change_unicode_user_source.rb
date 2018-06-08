require "rubygems"
require "active_record"
require 'uri'
require 'cgi'
ActiveRecord::Base.establish_connection(
  :adapter => "mysql",
  :host => '192.168.1.4',
  :username => 'root',
  :password => 'pingco82600011',
  :database => 'jc258_production' 
)
class UserSources < ActiveRecord::Base
    ENGINES = {
    :google     => [/^https?:\/\/(.*\.)?google.*/, 'q'],
    :yahoo      => [/^https?:\/\/([^\.]+.)?search\.yahoo.*/, 'p'],
    :bing       => [/^https?:\/\/(.*\.)?bing.*/, 'q'],
    :mbaidu      => [/^https?:\/\/m.baidu.*/, 'wd'],
    :hao123_baidu => [/^http?:\/\/www.baidu.com\/s\?word/, 'word'],
    :baidu      => [/^https?:\/\/(.*\.)?baidu.*/, 'wd'],
    :soso       => [/^https?:\/\/(.*\.)?soso.*/, 'w'],
    :sogou      => [/^https?:\/\/(.*\.)?sogou.*/, 'query'],
    :so         => [/^https?:\/\/(.*\.)?haosou.*/, 'q'],    
    :youdao     => [/^https?:\/\/(.*\.)?youdao.*/, 'q'],
    :panguso    => [/^https?:\/\/(search\.)?panguso.*/, 'q'],
    :msn        => [/^https?:\/\/search\.msn.*/, 'q'],
    :sm        => [/^https?:\/\/(.*\.)?sm.*/, 'q']        
    }

  def self.get_site_and_tags(referer)
    if (s = ENGINES.detect {|v| referer.match(v[1][0])})
      query_string = referer[referer.index("?")+1,referer.size] unless referer.index("?").blank?
      return nil if query_string.blank?
      tags = CGI.parse(query_string)[s[1][1]][0]
      referer =~ /utf-8|utf8|haosou|m\.baidu/i ? (tags.blank? ? CGI.parse(query_string)["word"][0] : tags)  :
          (tags.blank? ? URI.decode(CGI.parse(query_string)["word"][0]) : URI.decode(tags))
    else
      nil
    end
  end
   conn = ActiveRecord::Base.connection
   conn.execute("set names utf8")
   user_sources = conn.select_all("SELECT * FROM mbs_user_sources WHERE  referer != '' AND referer LIKE '%?%' ")
   user_sources.each do |user_source|
     referer = user_source["referer"]
     key_words = UserSources.get_site_and_tags referer
     conn.update_sql(%Q/update mbs_user_sources  set tags = '#{key_words}' where id = #{user_source["id"]}/)
   end
end
