require "colorize"
require 'pry-byebug'

class Display
    attr_reader :intro_message, 
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
    attr_reader :right_indexes, :round_counter, :codemaker_code, :codebreaker_guess, :intro_message, :choose_game, :temporal_breaker_arr, :temporal_maker_arr

    @@end_game = false

    def initialize
        @right_indexes = 0
        @right_numbers = 0
        @temporal_breaker_arr = []
        @temporal_maker_arr = []
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

    def check_number(breakercode, makercode)
        right_numbers = 0
        breakercode.map {|digit|
          for i in 0...makercode.length
            if digit == makercode[i]
              right_numbers += 1
              makercode[i] = 8
              break
            end
          end
        }
        right_numbers
    end

    def check_index(breaker_arr, maker_arr)
        indexes = 0
        @temporal_breaker_arr = breaker_arr.map {|digit| digit}
        @temporal_maker_arr = maker_arr.map {|digit| digit}
        for i in 0..3
            if breaker_arr[i] == maker_arr[i]
                indexes += 1
                @temporal_breaker_arr[i] = 0
                @temporal_maker_arr[i] = 7
            end
        end
        puts "this is temporal breaker #{@temporal_breaker_arr}"
        puts "this is temporal maker #{@temporal_maker_arr}"
        puts "this is breaker code #{@codebreaker_guess}"
        puts "this is maker code #{@codemaker_code}"
        indexes
    end

    def check_guess
        @right_indexes = check_index(@codebreaker_guess, @codemaker_code)
        puts @right_indexes
        @right_numbers = check_number(@temporal_breaker_arr, @temporal_maker_arr)
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

class PlayerCodeMakerGame < Game
    attr_reader :posible_comb, :codemaker_code, :guess_list

    def initialize
        puts "\nCreate the code using digits from 1 to 6 only and 4 digits length"
        @codemaker_code = gets.chomp.to_i.digits.reverse
        @posible_comb = (1..2).to_a 
        @posible_comb = @posible_comb.repeated_permutation(4).to_a
        @codebreaker_guess = [1, 1, 2, 2]
    end

    def get_guess #el problema está aquí y en Round, revisar
        if @round_counter == 1
            puts "\nComputer's round ##{round_counter}: #{@codebreaker_guess}"
        else
            @posible_comb.select! {|comb| check_index(comb, @codemaker_code) == @right_indexes && check_number(comb, @codemaker_code) == @right_numbers}
            @codebreaker_guess = @posible_comb[0]
            p @posible_comb
            puts "\nComputer's round ##{round_counter}: #{@codebreaker_guess}"
        end
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
    attr_accessor :codemaker_code, :right_indexes

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
