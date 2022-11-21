class Display
    attr_accessor :intro_message, 
    def initialize
    end

    def human_set_code
        @intro_message = "Enter the 4 digit code. Digits have to be from 1-6."
    end

end

class Human_solver
    attr_reader :guess_arr, :code_guess

    def initialize
        @code_guess = 0
    end
end

class HumanCodemaker
    def initialize
        puts "Create the code using digits from 1 to 6 only and 4 digits length"
        @human_code = gets.chomp.to_i.digits.reverse
    end
end

class Game
    attr_reader :machine_code, :guess_arr, :right_indexes, :round_counter, :human_code

    @@end_game = false

    def initialize
        @human_code = HumanCodemaker.new.human_code
        @machine_code = MachineCodeMaker.new.machine_code
        @guess_arr = []
        @intro_message = Display.new.human_set_code
        @round_counter = 1
        @code_history_arr = []
        @code_guess = Human_solver.new.code_guess
    end

    # gets the code from human with restrictions (only digits 1-6 and 4 digit length)
    def get_human_code
        @code_guess = gets.chomp.to_i
        @guess_arr = @code_guess.digits.reverse
        if @guess_arr.length < 4 || @guess_arr > 4
            puts "The code has to contain 4 digits, try again"
            get_human_code
        elsif (@guess_arr - [0, 7, 8, 9]).length < 4
            puts "The code can only contain digits from 1 to 6 both included. Try again"
            get_human_code
        end
    end

    def check_number
        @right_numbers = 4 - (@guess_arr - @machine_code).length
    end

    def check_index
        @right_indexes = 0
        for i in 0..3
            @guess_arr[i] == @machine_code[i] ? @right_indexes += 1 : next
        end
    end

    def check_guess
        check_number
        check_index
    end

    def give_feedback
        puts "You have #{@right_numbers} right digits and #{@right_indexes} are in the right position"
    end

    def game_over
        if @right_indexes == 4
            puts "\nCongratulations, you broke the code!"
            @@end_game = true
            return
        elsif @round_counter == 12
            puts "\nYou lose. The code was #{@machine_code}"
            @@end_game = true
            return
        else
            @round_counter += 1
        end
    end

    def round
        round_message
        get_human_code
        check_guess
        give_feedback
        game_over
    end

    def play
        puts @machine_code
        while @@end_game == false do
            round
        end
        play_again
    end

    def round_message
        puts "\nRound ##{@round_counter}: Enter a 4 digit code. Digits have to be from 1-6"
    end

    def play_again
        puts "\nWould you like to play again? Press 'y' if you want to continue, else press any other key."
        if gets.chomp == "y"
            @@end_game = false
            play
        end
    end

end

class MachineCodeMaker
    attr_reader :machine_code

    def initialize
        @machine_code = Array.new(4) {rand(1...6)}
    end
end

Game.new.human_code
