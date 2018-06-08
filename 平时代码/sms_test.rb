require "rubygems"
require "httparty"
# 发送短信接口URL，如无必要，该参数可不用修改
api_send_url="http://sms.253.com/msg/send"
# 创蓝帐号，替换成您自己的帐号
account="N6262319"
# 创蓝密码，替换成您自己的密码
pswd="lHEy0qaFW69d4d"
mobile="18701641826"

body={:un=> account,:pw => pswd,:phone=>mobile,:msg=>"【雅彩】22222222222",:rd=> 1 }

resp=HTTParty.post(api_send_url,:body => body)
puts resp.body
