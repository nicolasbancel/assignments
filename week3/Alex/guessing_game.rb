require 'byebug'

@number = rand(1..10)
@remaining_list = Array(1..10)
@guess = 0
@guess_list = []
#@answer = ""

def game
    until @number == @guess
        print "Here are your remaining numbers..."
        print @remaining_list
        puts ""
        puts "--------------------------------------------------------------------"
        print "What is your guess?-> "
        @guess = gets.chomp.to_i
        if @number == @guess
            puts "Congratulations! You guessed the correct number."
        elsif @number != @guess
            puts "Sorry, that is not the number. Please guess again."
            @guess_list.push(@guess)
            @remaining_list.delete(@guess)
        elsif @guess_list.include? @guess
            puts "#{@guess} has been used already, please guess another number."
        elsif @remaining_list.exclude? @guess
            puts "Please guess a number between 1 and 10."
        else
            puts "Error"
        end
    end
end

# until @answer == "y" || @answer == "n"
#     print "Do you want to play again?(y/n) "
#     @answer = gets.chomp.downcase
#     if @answer == "y"
#         puts "Let's play again!"
#         game()
#     elsif @answer == "n"
#         puts "Thanks for playing!!!"
#     else
#         puts "Please enter 'y' or 'n'!"
#     end
# end

def play_game
    answer = ""
    until answer == "n"
        game()
        byebug
        print "Do you want to play again?(y/n) "
        answer = gets.chomp.downcase
        if answer == "y"
            puts "Let's play again!"
        elsif answer == "n"
            puts "Thank you for playing!"
        else
            puts "Please put 'y' or 'n'."
        end
    end
end

play_game()
