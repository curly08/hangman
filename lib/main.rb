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
    @wrong_guesses = []
    @game_over = false
  end

  def play_game
    play_turn while @game_over == false
  end

  def play_turn
    puts "\n#{display.join(' ')}\n\n"
    puts "These are your previous incorrect guesses: #{@wrong_guesses.join(', ')}"
    input = player.choose_letter
    correct_guess?(input) if input.length > 1
    check_for_letter(input) if input.length == 1
    return unless @wrong_guesses == @max_wrong_guesses

    @game_over = true
    puts "\nYou lose because you hit the max number of incorrect guesses.\nThe word was \"#{secret_word}\"."
  end

  def correct_guess?(guess)
    if secret_word.casecmp?(guess)
      @game_over = true
      puts "\nCongrats! You won!"
    else
      @wrong_guesses.push(guess)
      puts "\nThat is not the correct word.\nIncorrect Guesses: #{@wrong_guesses.length}/#{@max_wrong_guesses}"
    end
  end

  def check_for_letter(letter)
    if secret_word.downcase.include?(letter)
      secret_word.split('').each_with_index do |v, i|
        display[i] = v if v.casecmp?(letter)
      end
      puts "\nYes! The word includes \"#{letter}\"\nIncorrect Guesses: #{@wrong_guesses.length}/#{@max_wrong_guesses}"
    else
      @wrong_guesses.push(letter)
      puts "\nSorry, the word does not include \"#{letter}\".\nIncorrect Guesses: #{@wrong_guesses.length}/#{@max_wrong_guesses}"
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
