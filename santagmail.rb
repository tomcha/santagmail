#!/usr/bin/env ruby
# coding:utf-8

require 'net/https'

config = eval File.read './.config/config.rb'

#コンシューマーkey,secret
client_id     = config[:client_id]
client_secret = config[:client_secret]
gmail_id = config[:gmail_id]

