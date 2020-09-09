require 'sinatra'
require 'json'
require 'sinatra/json'
require 'pry'

get '/health' do
  status 200
  body 'healthy'
end
