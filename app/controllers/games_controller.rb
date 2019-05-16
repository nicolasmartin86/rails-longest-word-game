require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(10)
  end

  def generate_grid(grid_size)
    size_array = (1..grid_size).to_a
    size_array.map do
      ('A'..'Z').to_a.sample
    end
  end

  def score
    @answer = params[:answer]
    @letters = params[:letters]
    @within_grid = within_grid(@answer)
    @call_api = call_api(@answer)
  end

  def call_api(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = open(url).read
    word = JSON.parse(word_serialized)
    word['found']
  end

  def within_grid(word)
    word_array = word.upcase.split('')
    letters_array = @letters.upcase.split(' ')
    word_array.all? do |letter|
      (letters_array.count(letter) > word_array.count(letter)) || (letters_array.count(letter) > 0)
    end
  end
end
