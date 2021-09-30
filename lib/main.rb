# frozen_string_literal: true

require 'pry-byebug'

# Game class
class Game
  attr_accessor :display, :game_over, :wrong_guesses
  attr_reader :secret_word, :word_list, :player, :max_wrong_guesses

  def initialize(player)
    @word_list = File.read('5desk.txt').split.select { |word| word if word.length.between?(5, 12) }
    @secret_word = word_list.sample
    @player = player
    @display = Array.new(secret_word.length, '_')
    @max_wrong_guesses = 6
    @wrong_guesses = 0
    @game_over = false
  end

  def play_game
    play_turn while @game_over == false
  end

  def play_turn
    puts secret_word
    puts display.join(' ')
    input = player.choose_letter
    correct_guess?(input) if input.length > 1
    check_for_letter(input) if input.length == 1
    return unless @wrong_guesses == @max_wrong_guesses

    @game_over = true
    puts 'You lose because you ran out of guesses.'
  end

  def correct_guess?(guess)
    if guess == secret_word
      @game_over = true
      puts 'Congrats! You won!'
    else
      @wrong_guesses += 1
      puts 'Incorrect'
    end
  end

  def check_for_letter(letter)
    if secret_word.downcase.include?(letter)
      secret_word.split('').each_with_index do |v, i|
        display[i] = v if v.casecmp?(letter)
      end
      puts "Yes! The word includes #{letter}"
    else
      @wrong_guesses += 1
      puts "Sorry, the word does not include \"#{letter}\""
    end
  end
end

# Player class
class Player
  def initialize(name)
    @name = name
    @guesses = []
  end

  def choose_letter
    puts 'Pick a letter or guess the word!'
    begin
      input = gets.chomp.downcase
      raise 'Invalid input! Type a letter or guess the word.' unless input.match?(/^[a-z]+$/i)
      raise 'You have already guessed that! Try something else.' unless @guesses.none?(input)

      @guesses.push(input)
      input
    rescue StandardError => e
      puts e.to_s
      retry
    end
  end
end

new_game = Game.new(Player.new('matt'))
new_game.play_game
