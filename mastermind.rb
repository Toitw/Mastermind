class Display

    def clues
    end

    def human_set_code
        puts "Enter the 4 digit code. Digits have to be from 1-6."
    end
end

class Human_solver
    attr_reader :guess_arr, :code_guess

    def initialize
        @code_guess = gets.chomp.to_i
    end
end

class Game
    attr_reader :machine_code, :guess_arr

    def initialize
        @machine_code = MachineCodeMaker.new.machine_code
        @display = Display.new
        @guess_arr = []
    end
    def get_human_code
        puts @display.human_set_code
        @code_guess = Human_solver.new.code_guess
        @guess_arr = @code_guess.digits.reverse
    end

    def check_number
        @right_numbers = 4 - (@guess_arr - @machine_code).length
    end

    def check_index
    end

    def check_guess
        check_number
        check_index
    end

    def round
    end

    def game_loop
    end

end

class MachineCodeMaker
    attr_reader :machine_code

    def initialize
        @machine_code = Array.new(4) {rand(1...6)}
    end
end

new_game = Game.new
new_game.get_human_code
p new_game.machine_code
p new_game.guess_arr
p new_game.check_number
