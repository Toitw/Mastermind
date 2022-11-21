class Display
    attr_accessor :intro_message, 
    def initialize
    end

    def human_set_code
        @intro_message = "Enter the 4 digit code. Digits have to be from 1-6."
    end

    def not_enough_digits
        puts "The code has to contain 4 digits, try again"
    end

    def incorrect_digits
        puts "The code can only contain digits from 1 to 6 both included. Try again"
    end

end

class Game
    attr_reader :right_indexes, :round_counter, :codemaker_code, :codebreaker_guess

    @@end_game = false

    def initialize
        @codebreaker_guess = []
        @intro_message = Display.new.human_set_code
        @round_counter = 1
        @code_history_arr = []
        @display = Display.new
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
            play
        end
    end

end

class MachineCodeBreaker
end

class PlayerCodeMakerGame < Game
    def initialize
        super
        puts "Create the code using digits from 1 to 6 only and 4 digits length"
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
        super
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

PlayerCodeBreakerGame.new.play
