# frozen_string_literal: true

class Hangman
  FNAME = "google-10000-english-no-swears.txt"
  ATTEMPTS = 8
  attr_accessor :word, :guessed, :attempts

  def initialize
    @word = select_word(FNAME)
    @guessed = Array.new(word.size, "_")
    @attempts = ATTEMPTS
    super
  end

  def select_word(fname)
    words = []
    File.readlines(fname).each do |line|
      words << line.chomp if line.size.between?(6, 13)
    end
    words.sample.downcase.chars
  end

  def guess
    loop do
      print "Guess a character: "
      char = gets.chomp.downcase
      return(char) if char.size == 1 && ("a".."z").include?(char)

      puts "Incorrect input, only single characters are allowed."
    end
  end

  def printout
    puts guessed.join(" ")
    puts "Remaining attempts: #{@attempts}/#{ATTEMPTS}"
  end
end

hm = Hangman.new
char = hm.guess
puts char
