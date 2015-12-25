#!/usr/bin/env ruby
# coding:utf-8

require 'net/https'
require 'json'

config = eval File.read './.config/config.rb'

#コンシューマーkey,secret
client_id     = config[:client_id]
client_secret = config[:client_secret]
gmail_id = config[:gmail_id]
capass = config[:capass]

redirect_uri  = "http://localhost"
scope         = "https://mail.google.com/" #ここの表現で出来ることを制御している？

# 自動部分
oauth_url = "https://accounts.google.com/o/oauth2/auth?client_id=#{client_id}&redirect_uri=#{redirect_uri}&scope=#{scope}&response_type=code&approval_prompt=force&access_type=offline"
`open "#{oauth_url}"`

print "認証コード(アドレスバーの?code=以下の部分全て)を入力してエンター："
code = gets.chomp

talken = `curl -d client_id=#{client_id} -d client_secret=#{client_secret} -d redirect_uri=#{redirect_uri} -d grant_type=authorization_code -d code=#{code} https://accounts.google.com/o/oauth2/token`

talken =~ /"access_token" : "(.*?)",/
access_token = $1 if $1
puts access_token

https = Net::HTTP.new('www.googleapis.com', 443)
https.use_ssl = true
https.ca_file = capass
https.verify_mode = OpenSSL::SSL::VERIFY_PEER
https.verify_depth = 5

https.start do |http|
  res = http.get("/gmail/v1/users/#{gmail_id}/messages", {'Authorization' => "Bearer #{access_token}"})
  @messagelist = JSON.parse(res.body)
end

@messagelist['messages'].each do |messagedata|
  puts messagedata
end
