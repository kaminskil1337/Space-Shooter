# frozen_string_literal: true

require 'json'
require 'httparty'

class ScoreManager
  def set_score(score, name)
    @score = score
    @name = name
    send_score
  end

  def send_score
    HTTParty.post('https://space-shooter-leaderboard.herokuapp.com/', body: { name: @name, score: @score }.to_json)
  end

  def get_high_score(a)
    response = HTTParty.get('https://space-shooter-leaderboard.herokuapp.com/response')
    response_json = JSON.parse(response)[a]
    @high_score_name = response_json['name']
    @high_score_score = response_json['score']
    @high_score_name + ' - ' + @high_score_score.to_s
  end
end
