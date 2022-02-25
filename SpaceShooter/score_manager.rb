# frozen_string_literal: true

require 'json'
require 'httparty'

class ScoreManager
  attr_reader :high_scores

  def send_score(score, name)
    HTTParty.post('https://space-shooter-leaderboard.herokuapp.com/scores', body: { name: name, score: score }.to_json)
  end

  def initialize
    response = HTTParty.get('https://space-shooter-leaderboard.herokuapp.com/scores')
    response_json = JSON.parse(response)
    @high_scores = response_json[0..2]
  end
end
