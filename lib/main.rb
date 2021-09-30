# frozen_string_literal: true

require 'yaml'

# Game class
class Game
  attr_accessor :display, :game_over, :wrong_guesses, :all_guesses
  attr_reader :secret_word, :word_list, :max_wrong_guesses

  def initialize(data = {})
    word_list = File.read('5desk.txt').split.select { |word| word if word.length.between?(5, 12) }
    @secret_word = data.fetch(:secret_word, word_list.sample)
    @display = data.fetch(:display, Array.new(secret_word.length, '_'))
    @max_wrong_guesses = data.fetch(:max_wrong_guesses, 6)
    @wrong_guesses = data.fetch(:wrong_guesses, [])
    @all_guesses = data.fetch(:all_guesses, [])
    @game_over = data.fetch(:game_over, false)
  end

  def play_game
    play_turn while @game_over == false
  end

  def play_turn
    puts "\n#{display.join(' ')}\n\n"
    puts "These are your previous incorrect guesses: #{@wrong_guesses.join(', ')}"
    input = choose_letter
    save_and_exit_game if input == 'save'
    correct_guess?(input) if input.length > 1 && input != 'save'
    check_for_letter(input) if input.length == 1
    return unless @wrong_guesses.length == @max_wrong_guesses

    @game_over = true
    puts "\nYou lose because you hit the max number of incorrect guesses.
          \nThe word was \"#{secret_word}\"."
  end

  def choose_letter
    puts 'Pick a letter or guess the word. Type "save" to save your game and exit this game.'
    begin
      input = gets.chomp.downcase
      raise 'Invalid input! Type a letter or guess the word.' unless input.match?(/^[a-z]+$/i)
      raise 'You have already guessed that! Try something else.' unless @all_guesses.none?(input)

      @all_guesses.push(input) unless input == 'save'
      input
    rescue StandardError => e
      puts e.to_s
      retry
    end
  end

  def correct_guess?(guess)
    if secret_word.casecmp?(guess)
      @game_over = true
      puts "\nCongrats! You won!"
    else
      @wrong_guesses.push(guess)
      puts "\nThat is not the correct word.
            \nIncorrect Guesses: #{@wrong_guesses.length}/#{@max_wrong_guesses}"
    end
  end

  def check_for_letter(letter)
    if secret_word.downcase.include?(letter)
      secret_word.split('').each_with_index do |v, i|
        display[i] = v if v.casecmp?(letter)
      end
      puts "\nYes! The word includes \"#{letter}\"
            \nIncorrect Guesses: #{@wrong_guesses.length}/#{@max_wrong_guesses}"
    else
      @wrong_guesses.push(letter)
      puts "\nSorry, the word does not include \"#{letter}\".
            \nIncorrect Guesses: #{@wrong_guesses.length}/#{@max_wrong_guesses}"
    end
  end

  def self.load_game?
    puts 'Type 1 to play a new game; type 2 to load a previous game'
    input = gets.chomp
    Game.new.play_game if input == '1'
    Game.from_yaml if input == '2'
  end

  def save_and_exit_game
    Dir.mkdir('saved-games') unless Dir.exist?('saved-games')
    puts "\nWhat would you like to save your game as?"
    begin
      input = gets.chomp
      raise 'Invalid filename!' unless input.match?(/^[A-Za-z0-9._ -]+$/i)

      filename = "saved-games/#{input}.yaml"
      File.open(filename, 'w') { |file| file.puts to_yaml }
    rescue StandardError => e
      puts e.to_s
      retry
    end
    exit
  end

  def to_yaml
    YAML.dump({ secret_word: @secret_word,
                display: @display,
                max_wrong_guesses: @max_wrong_guesses,
                wrong_guesses: @wrong_guesses,
                all_guesses: @all_guesses,
                game_over: @game_over })
  end

  def self.from_yaml
    puts 'Which game do you want to load?'
    input = gets.chomp
    data = YAML.load(File.read("saved-games/#{input}.yaml"))
    Game.new(data).play_game
  end
end

Game.load_game?
