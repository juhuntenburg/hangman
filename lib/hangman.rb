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
      words << line.chomp if line.size >= 6 && line.size <= 13
    end
    words.sample.chars
  end

  def printout
    puts guessed.join(" ")
    puts "Remaining attempts: #{@attempts}/#{ATTEMPTS}"
  end
end

hm = Hangman.new
hm.printout
