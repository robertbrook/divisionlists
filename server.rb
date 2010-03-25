require 'rubygems'
require 'sinatra'
require 'rest_client'
require 'json'

DB = 'http://localhost:5984/divisionlists'

get '/divisions/number/:numberkey.xml' do
  data = RestClient.get "#{DB}/_design/divisions/_view/by_number?key=%22#{params[:numberkey]}%22"
    result = JSON.parse(data.body)
    division = result["rows"].first["value"]
    content_type 'text/xml', :charset => 'utf-8'
  %Q{<?xml version="1.0" encoding="UTF-8"?>
    <division>
    <h1>#{division["number"]}</h1>
    <blockquote>#{division["resolution"]}</blockquote>
<pre>#{division.inspect}</pre>
</division>
}
end

