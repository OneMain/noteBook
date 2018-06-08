require 'rubygems'
require 'rack'
rack_app = lambda{|env|
  request = Rack::Request.new(env)
  response = Rack::Response.new
  body = "==============header========<br/>"
  if request.path_info == "/BJ"
      body << "Wellcome from BeiJing"
  else
     body << "Wellcome from ervrycity"
 end
 body << "=============footer==========="
 response.body=[body]
 response.finish
}

rack_app_write = lambda{|env|
  request = Rack::Request.new(env)
  response = Rack::Response.new
  body = "==============header========<br/>"
  if request.path_info == "/BJ"
      body << "Wellcome from BeiJing"
  else
     body << "Wellcome from ervrycity"
 end
 body << "=============footer==========="
 response.write(body)
 response.finish
}

#Rack::Handler::WEBrick.run rack_app,:Port => 3333
Rack::Handler::WEBrick.run rack_app_write,:Port => 3333
