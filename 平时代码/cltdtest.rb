require 'net/http'
require 'uri'
class Test  
  def test
    uri = URI.parse('http://211.147.239.62:9050/cgi-bin/sendsms')
    http = Net::HTTP.new(uri.host,uri.port)
    res = Net::HTTP::GET.new(uri.path)
    params = {:username => "",:password => "",:to => "18701641826",:text => "测试信息",:msgtype => 1}
  end

  maps = {:mhtOrderNo => "762382",:mhtReqTime => req_time}                                                    
  need_params = maps.map{|key,value|key.to_s.concat("=#{value}")}.sort{|a,b|a.to_s <=> b.to_s}.join("&") 
end
