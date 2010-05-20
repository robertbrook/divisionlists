require 'rubygems'
require 'sinatra'
require 'rest_client'
require 'json'
require 'erb'
require 'date'
require 'haml'
require 'sass'

DB = 'http://localhost:5984/divisionlists'

get '/' do
  @title = "Search"
  haml :index
end

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

get '/divisions/number/:numberkey.csv' do
end

get '/divisions' do
  haml :divisions
end

get '/divisions/number/:numberkey' do
  data = RestClient.get "#{DB}/_design/divisions/_view/by_number?key=%22#{params[:numberkey]}%22"
  result = JSON.parse(data.body)
  
  @division = result["rows"][0]["value"]
    
  date = Date.new(@division["numeric_date"][0].to_i, @division["numeric_date"][1].to_i, @division["numeric_date"][2].to_i)
  hansard_date = date.strftime('%Y/%b/%d').downcase
  @archive_link = "http://hansard.millbanksystems.com/sittings/#{hansard_date}"
  
  @title = "Division number #{params[:numberkey]}, #{@division['date']}"
  
  haml :numbered_division
end

get '/styles.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :styles
end

get '/search' do
  @title = "Search"
  
  data = RestClient.get "#{DB}/_design/index/_view/constituency?key=%22#{params[:q].downcase}%22"
  result = JSON.parse(data.body)
  
  @constituencies = result["rows"].collect { |x| x["value"]["number"] }
  
  haml :search
end

get '/favicon.ico' do
  ""
end

