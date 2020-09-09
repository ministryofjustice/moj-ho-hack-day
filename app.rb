require 'sinatra'
require 'json'
require 'sinatra/json'
require 'pry'

get '/health' do
  status 200
  body 'healthy'
end

get '/' do
  start_page = JSON.parse(
    File.read(
      File.join(
        File.dirname(__FILE__),
       'metadata/page/page.start.json'
      )
    )
  )

  steps = start_page['steps']
  next_page = steps.first

  next_json = JSON.parse(
    File.read(
      File.join(
        File.dirname(__FILE__),
         "metadata/page/#{next_page}.json"
      )
    )
  )
  next_url = next_json['url']

  erb :index, locals: {
    heading: start_page['heading'],
    lede: start_page['lede'],
    next_url: next_url
  }
end

get '/basic-details' do
  erb :base_details
end
