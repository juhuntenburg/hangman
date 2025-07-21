# frozen_string_literal: true

class Hangman
  FNAME = "google-10000-english-no-swears.txt"
  ATTEMPTS = 8
  attr_accessor :word, :guessed, :attempts

  def initialize(debug: false)
    @word = select_word(FNAME)
    @guessed = Array.new(word.size, "_")
    @attempts = ATTEMPTS
    puts word.join if debug
    super()
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
      print "Guess a character: "
      char = gets.chomp.downcase
      return(char) if char.size == 1 && ("a".."z").include?(char)

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

hm = Hangman.new(debug: true)
hm.play
