require 'rubygems'
require 'sinatra'
require 'rest_client'
require 'json'
require 'erb'
require 'date'
require 'haml'

DB = 'http://localhost:5984/divisionlists'

get '/divisions/number/:numberkey.xml' do
  data = RestClient.get "#{DB}/_design/divisions/_view/by_number?key=%22#{params[:numberkey]}%22"
  result = JSON.parse(data.body)
  @division = result["rows"].first["value"]
  
  date = Date.new(@division["numeric_date"][0].to_i, @division["numeric_date"][1].to_i, @division["numeric_date"][2].to_i)
  hansard_date = date.strftime('%Y/%b/%d').downcase
  @archive_link = "http://hansard.millbanksystems.com/sittings/#{hansard_date}"
  
  content_type 'text/xml', :charset => 'utf-8'
  erb :numbered_division, :format => :xml, :layout => false
end

get '/divisions' do
  haml :divisions
end

get '/' do
  haml :index
end

get '/search' do
  haml :search
end

get '/favicon.ico' do
  ""
end