require 'rubygems'
require 'sinatra'
require 'rest_client'
require 'json'
require 'erb'

DB = 'http://localhost:5984/divisionlists'

get '/divisions/number/:numberkey.xml' do
  data = RestClient.get "#{DB}/_design/divisions/_view/by_number?key=%22#{params[:numberkey]}%22"
  result = JSON.parse(data.body)
  @division = result["rows"].first["value"]
  content_type 'text/xml', :charset => 'utf-8'
  erb :numbered_division, :format => :xml
end

