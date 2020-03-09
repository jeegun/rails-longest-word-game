require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ("a".."z").to_a[rand(26)] }
  end

  def call_api
    @attempt = params[:word]
    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    attempt_serialized = open(url).read
    JSON.parse(attempt_serialized)
  end

  def score
    attempt = call_api
    attempt_array = attempt["word"].split("")

    grid_checker = attempt_array.all? do |l|
      attempt_array.count(l) <= params[:grid].split(" ").count(l)
    end

    if attempt["found"] == false
      @result = "Sorry, #{attempt["word"]} is not an english word"
    elsif attempt["found"] && grid_checker == false
      @result = "Sorry, #{attempt["word"]} is not in the grid"
    else
      @result = "Congratulations, #{attempt["word"]} is a valid English word"
    end
  end
end
