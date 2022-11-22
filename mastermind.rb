class Display
    attr_accessor :intro_message, 
    def initialize
    end

    def intro_message
        puts "Welcome! The game consists in decipher the code. There is a codemaker and a codebreaker.\n\nThe codemaker will give hints after each"\
        " attempt from the codebreaker. The hints will tell how many numbers are correct, and how many are in the correct position.\n\n"\
        "The codebreaker has 12 turns to decipher the code. But first, do you want to be codemaker or codebreaker?\n\n"\
        "For playing as a codemaker enter '1'. To be the codebreaker, enter '2'."
    end

    def not_enough_digits
        puts "The code has to contain 4 digits, try again"
    end

    def incorrect_digits
        puts "The code can only contain digits from 1 to 6 both included. Try again"
    end

end

class Game
    attr_reader :right_indexes, :round_counter, :codemaker_code, :codebreaker_guess, :intro_message, :choose_game

    @@end_game = false

    def initialize
        @codebreaker_guess = []
        Display.new.intro_message
        @round_counter = 1
        @code_history_arr = []
        @display = Display.new
        choose_game
    end

    def choose_game
        @choose_game = gets.chomp.to_i
        if @choose_game == 1
            PlayerCodeMakerGame.new.play
        elsif @choose_game == 2
            PlayerCodeBreakerGame.new.play
        else
            puts "Please, choose between 1 or 2 to play"
            choose_game
        end
    end

    def codemaker_restrictions
        if @codemaker_code.length > 4 || @codemaker_code.length < 4
            @display.not_enough_digits
        end
    end

    def check_number
        @right_numbers = 4 - (@codebreaker_guess - @codemaker_code).length
    end

    def check_index
        @right_indexes = 0
        for i in 0..3
            @codebreaker_guess[i] == @codemaker_code[i] ? @right_indexes += 1 : next
        end
    end

    def check_guess
        check_number
        check_index
    end

    def give_feedback
        puts "\nYou have #{@right_numbers} right digits and #{@right_indexes} are in the right position"
    end

    def game_over
        if @right_indexes == 4
            puts "\nCongratulations, you broke the code!"
            @@end_game = true
            return
        elsif @round_counter == 12
            puts "\nYou lose. The code was #{@codemaker_code}"
            @@end_game = true
            return
        else
            @round_counter += 1
        end
    end

    def play
        @round_counter = 1
        while @@end_game == false do
            round
        end
        play_again
    end

    def round_message
        puts "\nPlayer's round ##{@round_counter}: Enter a 4 digit code. Digits have to be from 1-6"
    end

    def play_again
        puts "\nWould you like to play again? Press 'y' if you want to continue, else press any other key."
        if gets.chomp == "y"
            @@end_game = false
            Game.new.play
        end
    end

end

class MachineCodeBreaker
end

class PlayerCodeMakerGame < Game
    def initialize
        puts "\nCreate the code using digits from 1 to 6 only and 4 digits length"
        @codemaker_code = gets.chomp.to_i.digits.reverse
    end

    def get_guess
        @codebreaker_guess = Array.new(4) {rand(1...6)}
        puts "\nComputer's round ##{round_counter}: #{@codebreaker_guess}"
    end

    def round
        get_guess
        check_guess
        give_feedback
        sleep(1)
        game_over
    end

end

class PlayerCodeBreakerGame < Game
    def initialize
        @codemaker_code = Array.new(4) {rand(1...6)}
    end

    # gets the code from human with restrictions (only digits 1-6 and 4 digit length)
    def get_guess
        @codebreaker_guess = gets.chomp.to_i.digits.reverse
        if @codebreaker_guess.length < 4 || @codebreaker_guess.length > 4
            @display.not_enough_digits
            get_guess
        elsif (@codebreaker_guess - [0, 7, 8, 9]).length < 4
            @display.incorrect_digits
            get_guess
        end
    end

    def round
        round_message
        get_guess
        check_guess
        give_feedback
        game_over
    end

end

Game.new.play
