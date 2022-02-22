# frozen_string_literal: true

require 'sinatra/reloader'
require 'json'

class Leaderboard < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/star_shooter_leaderboard' do
    file = File.read('./data.json')
    @items = JSON.parse(file)
    erb :index
  end

  get '/star_shooter_leaderboard_response' do
    file = File.read('./data.json')
    return file
  end

  post '/star_shooter_leaderboard' do
    file = File.read('./data.json')
    data_hash = JSON.parse(file)
    new_data = JSON.parse(request.body.read)
    data_hash << new_data
    sorted = (JSON[data_hash.to_json].sort_by { |e| e['score'].to_i }).reverse
    File.write('./data.json', JSON.dump(sorted[0..10]))
    redirect '/star_shooter_leaderboard'
    return 200
  end
end
