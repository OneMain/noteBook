# encode:utf8
require "rubygems"
require 'cgi'
require 'uri'
require 'net/http'
require 'net/https'
require 'date'
require "openssl" 
require "md5"
require "base64"
class PayByOther
  APPID = "1409801351286401"
  DESKEY="psWEmj2sRNhADHjTaHCnpKpK"
  MD5KEY="vtnkfo3TchHUHshxw2lehzQUK0Lh03Nz"
  IPHER = "des-ede3"
  def pay
    begin
     req_time = DateTime.now.strftime("%Y%m%d%H%M%S")
     uri = URI.parse("https://211.154.166.175/agentpay/agentPayQuery")
      https = Net::HTTP.new(uri.host,uri.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      res = Net::HTTP::Post.new(uri.path)
      maps = {:mhtOrderNo => "762382",:mhtReqTime => req_time}
      need_params = maps.map{|key,value|key.to_s.concat("=#{value}")}.sort{|a,b|a.to_s <=> b.to_s}.join("&")
      appid = Base64.encode64("appId=#{APPID}")
      puts "need_params+MD5KEY:" + need_params+MD5KEY
      md5_key = Base64.encode64(MD5.hexdigest(need_params+MD5KEY))
      des_params = Base64.encode64(des_encode(need_params))
      message =  [appid,des_params,md5_key].join("|") 
      par = "funcode=AP07&message=#{ URI.escape(message)}"
      res.body = par
      res = https.request(res)
     if res.body.split("|").include?("0")
      puts Base64.decode64(res.body.split("|").last)
     else
      puts respstr_to_hash(res.body)
    end
    rescue Exception => e
      puts e.message
    end    
 end

  def des_encode(str)
    c = OpenSSL::Cipher::Cipher.new("des-ede3")
    c.key = DESKEY
    c.encrypt
    ret = c.update(str.to_s)
    ret << c.final
  end

  def des_decode(str)
    c = OpenSSL::Cipher::Cipher.new("des-ede3")
    c.key = DESKEY
    c.decrypt
    c.padding=0
    c.update(str.to_s)
  end

  def respstr_to_hash(res_body)
    respond_body = res_body.split("|")
    if respond_body.first == "0"
      {"responseMsg" => Base64.decode64(respond_body.last),  "respon_statu" => respond_body.first}
    else
      Hash[des_decode(Base64.decode64(respond_body[1])).rstrip().split("&").map { |a| a.split("=") }].merge({"respon_statu" =>respond_body.first })
    end

  end

end
PayByOther.new.pay

