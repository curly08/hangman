# frozen_string_literal: true

# Game class
class Game
  attr_accessor :display
  attr_reader :secret_word, :word_list

  def initialize
    @word_list = File.read('5desk.txt').split.select { |word| word if word.length.between?(5, 12) }
    @secret_word = word_list.sample
    @display = String.new.ljust(secret_word.length, '_')
  end
end

# Player class
class Player
  def initialize
    puts 'What is your name?'
    @name = gets.chomp
  end
end

def choose_letter
  letter = gets.chomp
end

Game.new
