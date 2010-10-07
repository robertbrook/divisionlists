require 'rubygems'
require 'sinatra'
require 'rest_client'
require 'json'
require 'erb'
require 'date'
require 'haml'
require 'sass'
require 'cgi'

configure do
  set :db, 'http://localhost:5984/divisionlists'
end

get '/' do
  @title = "Search"
  haml :index
end

get '/divisions/:year/number/:numberkey.xml' do
  data = RestClient.get "#{settings.db}/_design/data/_view/divisions-by-number?key=%22#{params[:numberkey]}%22"
  result = JSON.parse(data.body)
  @division = result["rows"].first["value"]
  
  date = Date.new(@division["numeric_date"][0].to_i, @division["numeric_date"][1].to_i, @division["numeric_date"][2].to_i)
  hansard_date = date.strftime('%Y/%b/%d').downcase
  @archive_link = "http://hansard.millbanksystems.com/sittings/#{hansard_date}"
  
  content_type 'text/xml', :charset => 'utf-8'
  erb :numbered_division, :format => :xml, :layout => false
end

get '/divisions/:year/number/:numberkey.csv' do
end

get '/divisions' do
  haml :divisions
end

get '/divisions/:year/number/:numberkey' do
  data = RestClient.get "#{settings.db}/_design/data/_view/divisions-by-year-and-number?key=%22#{params[:year]}-#{params[:numberkey]}%22"
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
  
  term = CGI.escape(params[:q].downcase)
  
  @term = Rack::Utils.escape_html(params[:q])
  
  #search
  data = RestClient.get "#{settings.db}/_fti/_design/data/test?q=%22#{term}%22"
  result = JSON.parse(data.body)
  
  @divisions = result["rows"]
  
  haml :search
end

get '/favicon.ico' do
  ""
end

