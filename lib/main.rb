# frozen_string_literal: true

# Game class
class Game
  attr_accessor :display
  attr_reader :secret_word, :word_list

  def initialize
    @word_list = File.read('5desk.txt').split.select { |word| word if word.length.between?(5, 12) }
    @secret_word = word_list.sample
    @display = String.new.ljust(secret_word.length, '_')
    @game_over = false
  end
end

# Player class
class Player
  def initialize(name)
    @name = name
  end
end

def choose_letter
  puts 'Guess a letter!'
  begin
    input = gets.chomp
    return input if input.match(/^[A-Z]+$/i) && input.length == 1

    raise 'Invalid input'
  rescue
    puts 'Invalid input. Type one letter.'
    retry
  end
end

# Game.new
