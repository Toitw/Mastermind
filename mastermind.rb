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

class Game
    attr_reader :machine_code, :guess_arr, :right_indexes, :round_counter

    @@end_game = false

    def initialize
        @machine_code = MachineCodeMaker.new.machine_code
        @guess_arr = []
        @intro_message = Display.new.human_set_code
        @round_counter = 1
        @code_history_arr = []
        @code_guess = Human_solver.new.code_guess
    end
    def get_human_code
        @code_guess = gets.chomp.to_i
        @guess_arr = @code_guess.digits.reverse
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
            puts "You broke the code!"
            @@end_game = true
            return
        elsif @round_counter == 6
            puts "You lose"
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

    def game_loop
        puts @machine_code
        while @@end_game == false do
            round
        end
    end

    def round_message
        puts "Round ##{@round_counter}: Enter a 4 digit code. Digits have to be from 1-6"
    end

end

class MachineCodeMaker
    attr_reader :machine_code

    def initialize
        @machine_code = Array.new(4) {rand(1...6)}
    end
end

new_game = Game.new
new_game.game_loop
