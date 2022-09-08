# frozen_string_literal: true

# require_relative 'validation'
require_relative 'player'
require_relative 'deck'
require_relative 'card'
require_relative 'blackjack'
require_relative 'constant_values'

class Game
  include ConstantValues

  def start
    puts 'Здравствуйте, как Вас зовут?'
    name = gets.chomp.capitalize

    puts "#{name}, играем в Blackjack?\n1. Да\n2. Нет\n"

    # create a deck of cards
    user = Player.new name, [], INITIAL_MONEY, 0
    dealer = Player.new 'Dealer', [], INITIAL_MONEY, 0
    deck = Deck.new

    loop do
      answer = gets.chomp.to_i

      case answer
      when 2
        puts 'Приходите ещё!'
        break

      when 1
        puts `clear`
        user.clear_player
        dealer.clear_player

        new_game = Blackjack.new user, dealer, deck

        new_game.menu(user, dealer, deck)

        puts "Счет ваших карт #{user.total}"
        puts "Счет карт диллера #{dealer.total}"
      else
        puts 'Приходите ещё!'
        break
      end

      if user.total <= BLACKJACK && dealer.total <= BLACKJACK

        if user.total > dealer.total
          puts 'Вы выйграли!'
          user.bankroll += BID
          dealer.bankroll -= BID

        elsif user.total < dealer.total
          puts 'Дилер победил!'
          user.bankroll -= BID
          dealer.bankroll += BID
        else
          puts 'Ничья!'
        end

      elsif user.total > BLACKJACK && dealer.total <= BLACKJACK
        puts 'У вас больше 21. Дилер победил!'
        user.bankroll -= BID
        dealer.bankroll += BID

      elsif user.total <= BLACKJACK && dealer.total > BLACKJACK
        puts 'У дилера больше 21. Вы победили!'
        user.bankroll += BID
        dealer.bankroll -= BID

      else
        puts 'Ничья!'
      end

      puts "На Вашем счету $#{user.bankroll}"
      puts "На счету дилера $#{dealer.bankroll}\n\n"

      if user.bankroll <= 0
        puts 'У Вас закончились деньги... '
        break
      else
        puts "Поиграем ещё?\n1. Да\n2. Нет\n"
      end
    end
  end
end
