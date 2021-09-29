# frozen_string_literal: true

require 'pry-byebug'

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
    @guessed_letters = []
  end

  def choose_letter
    puts 'Guess a letter!'
    begin
      input = gets.chomp.downcase
      raise 'Invalid input! Type a letter.' unless input.match?(/^[a-z]+$/i) && input.length == 1
      raise 'You have already guessed that letter!' unless @guessed_letters.none?(input)

      @guessed_letters.push(input)
      input
    rescue StandardError => e
      puts e.to_s
      retry
    end
  end
end

# def store_guess(guess)
#   puts guessed_letters
# end


# def compare_guess(letter, secret_word)
#   if secret_word.include?(letter) do
    
#   end
# end

# Game.new
matt = Player.new('matt')
