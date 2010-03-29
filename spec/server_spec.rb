require File.dirname(__FILE__) + '/spec_helper'

describe "My App" do
  include Rack::Test::Methods

  def app
    @app ||= Sinatra::Application
  end

  # it "should respond to '/divisions/number/171.xml'" do
  #     get '/divisions/number/171.xml'
  #     last_response.should be_ok
  #   end
  
  
end
