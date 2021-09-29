word_list = File.read('5desk.txt')

class Game
  attr_accessor :display
  attr_reader :secret_word

  def initialize
    @secret_word = word_list.split.sample
    @display = String.new.ljust(secret_word.length, '_')
  end
end

class Player
  def initialize
    puts 'What is your name?'
    @name = gets.chomp
  end
end

def choose_letter
  letter = gets.chomp
end