require 'db_helper'
require 'rubygems'
require 'rest_client'

result = RestClient.put("#{DATABASE}", '')

p result
