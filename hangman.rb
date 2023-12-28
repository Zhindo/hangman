require 'csv'
require 'yaml'


class Player
    attr_accessor :name, :tries, :word, :guess
    

    def initialize(name, word, guess)
        @name = name
        @tries = 5
        @word = word
        @guess = guess
    end

    def subtract_tries()
        @tries -= 1
        return @tries
    end

    def to_yaml
        YAML.dump({
            :name => @name,
            :tries => @tries,
            :word => @word,
            :guess => @guess,
        })
    end

    def self.from_yaml(string)
        data = YAML.load string
        p data
        self.new(data[:name], data[:tries], data[:word], data[:guess])
    end

end

def get_word(lists)

    revised_list = []

    lists.each do |list|
        list.each do |word|
            if word.length > 4 && word.length < 13
                revised_list << word
            end
        end
    end
    
    list_length = revised_list.length

    word = revised_list[rand(0...list_length)]

    return word

end

def hangman(player)

    alphabet = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']
    print "#{player.word}\n"
    word = player.word
    words = word.split("")

    gameComplete = false

    while player.tries > 0 && gameComplete == false

        available_word = alphabet.join(" ")

        puts "\n#{available_word}"

        puts "\nWhat letter will you choose?"
        choice = gets.chomp
        index = 0

        if words.include?(choice) && (alphabet.include?(choice.upcase)) == true
            alphabet.delete(choice.upcase)
            words.each_index do | letter |
                if words[letter] == choice
                    player.guess[letter].replace(words[letter])
                end
            end
        
        elsif (alphabet.include?(choice.upcase)) == false
            puts "\nWrong input. Try again"
        else
            alphabet.delete(choice.upcase)
            player.subtract_tries
            puts "\nWrong. You have #{player.tries} left"
        end

        print "\n#{player.guess.join(" ")}"

        puts "\nPress 1 to Save the Game and Press any character to continue the game"
        answer = gets.chomp
        puts answer

        if answer == '1'
            player.to_yaml
            player.tries = 0
            puts player.tries
            gameComplete = true

        else
            next

        end
        
        if player.tries == 0
            puts "\nYou Lose!"
            puts "The word is #{words.join("")}"
        end

        if player.guess.join("").include?('_') == false
            gameComplete = true
            player.tries = 0
            puts player.tries
            puts "You Win!"
        end


    end
    
end


# Ask for the Player's choice

puts "Press 1 to play a New Game, Press 2 to Load a Saved Game"
answer = gets.chomp

if answer == '1'
    continue
elsif answer == '2'
    p = Player.from_yaml(p.to_yaml)
    puts "Name: #{p.name}"
    puts "Tries: #{p.tries}"
    puts "Guess: #{p.guess}"

end


dictionary = CSV.read('google-10000-english-no-swears.txt')

word = get_word(dictionary)
words = word.split("")
tempWord = words.map {|letter| letter = "_"}

puts "What's your name? "


name = gets.chomp

player = Player.new(name, word, tempWord)

hangman(player)
