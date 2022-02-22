# frozen_string_literal: true

require 'sinatra/reloader'
require 'json'

class Leaderboard < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    file = File.read('./data.json')
    @items = JSON.parse(file)
    erb :index
  end

  get '/response' do
    file = File.read('./data.json')
    return file
  end

  post '/' do
    file = File.read('./data.json')
    data_hash = JSON.parse(file)
    new_data = JSON.parse(request.body.read)
    data_hash << new_data
    sorted = (JSON[data_hash.to_json].sort_by { |e| e['score'].to_i }).reverse
    File.write('./data.json', JSON.dump(sorted[0..10]))
    return 200
  end
end
