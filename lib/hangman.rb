# frozen_string_literal: true

require "json"

# Class to initialize and play the game
class Hangman
  CACHE = File.join(File.expand_path("..", __dir__), "cache")
  FNAME = "google-10000-english-no-swears.txt"
  ATTEMPTS = 8
  attr_accessor :word, :guessed, :attempts

  def initialize
    return if continue_previous?

    @word = select_word(FNAME)
    @guessed = Array.new(word.size, "_")
    @attempts = ATTEMPTS
    puts word
  end

  def continue_previous?
    answer = nil
    until %w[y n].include?(answer)
      print "Load previous game (Y/N)?"
      answer = gets.chomp.downcase
    end
    answer == "y" ? load_file : false
  end

  def load_file
    if Dir.exist?(CACHE) && !Dir.entries(CACHE).empty?
      latest_file = Dir.glob("#{CACHE}/*").max_by { |f| File.mtime(f) }
      parse_game(latest_file)
    else
      puts "No previous game found. Starting new game."
    end
  end

  def parse_game(fname)
    game = JSON.load_file(fname, symbolize_names: true)
    @word = game[:word]
    @guessed = game[:guessed]
    @attempts = game[:attempts]
  end

  def save_game
    puts "Saved game, you can choose to continue next time."
    game = { word: word, guessed: guessed, attempts: attempts }
    Dir.mkdir(CACHE) unless Dir.exist?(CACHE)
    now = Time.now.strftime("%Y%m%d_%H%M%S")
    File.write("#{CACHE}/hangman_#{now}.json", JSON.pretty_generate(game))
    exit(0)
  end

  def select_word(fname)
    words = []
    File.readlines(fname).each do |line|
      words << line.chomp if line.size.between?(6, 13)
    end
    words.sample.downcase.chars
  end

  def play
    8.times do
      per_attempt
      break if guessed.count("_").zero?
    end
    guessed.count("_").zero? ? puts("\nYou won!") : puts("\nYou lost!")
    puts word.join(" ")
  end

  def per_attempt
    loop do
      printout
      break unless update_guessed(guess)
      return if guessed.count("_").zero?
    end
    self.attempts -= 1
    printout
  end

  def guess
    loop do
      print "Guess a character (or press '*' to save the game): "
      char = gets.chomp.downcase
      return(char) if char.size == 1 && ("a".."z").include?(char)
      return save_game if char == "*"

      puts "Incorrect input, only single characters are allowed."
    end
  end

  def update_guessed(char)
    puts "You already guessed this character correctly" if guessed.include?(char)
    indices = word.each_index.select { |i| word[i] == char }
    indices.empty? ? false : indices.each { |i| guessed[i] = char }
  end

  def printout
    puts "\n#{guessed.join(' ')}"
    puts "Remaining attempts: #{@attempts}/#{ATTEMPTS}"
  end
end

hm = Hangman.new
# hm.play
hm.play
