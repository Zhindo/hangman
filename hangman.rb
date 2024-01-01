require 'csv'
require 'yaml'


class Player
    attr_accessor :name, :tries, :word, :guess
    

    def initialize(name)
        @name = name
        @tries = 5
        @word = get_word()
        @guess = guesses(@word)
    end

    def subtract_tries()
        @tries -= 1
        return @tries
    end

    def get_word()

        dictionary = CSV.read('google-10000-english-no-swears.txt')

        revised_list = []
    
        dictionary.each do |list|
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

    def guesses(word)
        words = word.split("")
        tempWord = words.map {|letter| letter = "_"}
        return tempWord
    end

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

        puts "\nWhat letter will you choose? Type 'save' if you want to save the game."
        choice = gets.chomp
        index = 0

        if words.include?(choice) && (alphabet.include?(choice.upcase)) == true
            alphabet.delete(choice.upcase)
            words.each_index do | letter |
                if words[letter] == choice
                    player.guess[letter].replace(words[letter])
                end
            end
        
        elsif choice == "save"
            save_account(player)
            exit
            
        elsif (alphabet.include?(choice.upcase)) == false
            puts "\nWrong input. Try again"
        else
            alphabet.delete(choice.upcase)
            player.subtract_tries
            puts "\nWrong. You have #{player.tries} left"
        end

        puts "\n#{player.guess.join(" ")}"

        if player.tries == 0
            puts "\nYou Lose!"
            puts "The word is #{words.join("")}"
        end

        if player.guess.join("").include?('_') == false
            puts "\nYou Win!"
            exit
        end


    end
    
end


def save_account(game)

    puts "What's the file name?"
    filename = gets.chomp
    return false unless filename
    dump = YAML.dump(game)
    File.open(File.join(Dir.pwd, "/saved/#{filename}.yaml"), 'w') { |file| file.write dump }

end


def load_account()

    puts "Here are the current saved games. Please choose which you'd like to load."

    filenames = Dir.glob('saved/*').map { |file| file[(file.index('/') + 1)...(file.index('.'))] }
    puts filenames
    filename = gets.chomp
    while filenames.include?(filename) != true
        puts "File name does not exist. Try again"
        puts filenames
        filename = gets.chomp
    end
    puts "#{filename} loaded..."
    
    saved = File.open(File.join(Dir.pwd, "saved/#{filename}.yaml"))
    loaded_game = YAML.unsafe_load(saved)
    saved.close
    
    hangman(loaded_game)

end



def new_game()

    puts "What's your name? "

    name = gets.chomp
        
    player = Player.new(name)

    hangman(player)
end

# Ask for the Player's choice

puts "Press 1 to play a New Game, Press 2 to Load a Saved Game"
answer = gets.chomp

if answer == '1'
    new_game()
elsif answer == '2'
    load_account()
end






