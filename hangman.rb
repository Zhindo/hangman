require 'csv'

class Player
    attr_accessor :name, :tries
    

    def initialize(name)
        @name = name
        @tries = 5
    end

    def subtract_tries()
        @tries -= 1
        return @tries
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

def hangman(word, player)

    alphabet = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']
    print "#{word}\n"
    word = word.split("")
    tempWord = word.map {|letter| letter = "_"}

    while player.tries > 0 || gameComplete != true

        available_word = alphabet.join(" ")

        puts available_word

        puts "What letter will you choose?"
        choice = gets.chomp
        index = 0

        if word.include?(choice) && (alphabet.include?(choice.upcase)) == true
            alphabet.delete(choice.upcase)
            word.each_index do | letter |
                if word[letter] == choice
                    tempWord[letter].replace(word[letter])
                end
            end
        
        elsif (alphabet.include?(choice.upcase)) == false
            puts "Wrong input. Try again"
        else
            alphabet.delete(choice.upcase)
            player.subtract_tries
            puts "Wrong. You have #{player.tries} left"
        end

        print "#{tempWord.join(" ")}\n"
        

    end
    
end

dictionary = CSV.read('google-10000-english-no-swears.txt')

word = get_word(dictionary)

puts "What's your name? "

name = gets.chomp

player = Player.new(name)

hangman(word, player)
