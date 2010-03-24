require 'rubygems'
require 'sinatra'
require 'rest_client'
require 'json'

DB = 'http://localhost:5984/divisionlists'

get '/divisionlists/' do
  data = RestClient.get "#{DB}/_design/divisionlists/_view/divisionlists"
  result = JSON.parse(data)
  %Q{
<h1>HELLO</h1>
}
end