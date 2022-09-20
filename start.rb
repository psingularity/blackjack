# frozen_string_literal: true

require_relative 'validation'
require_relative 'player'
require_relative 'deck'
require_relative 'card'
require_relative 'blackjack'
require_relative 'constant_values'

class Game
  include ConstantValues
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def start
    puts 'Здравствуйте, как Вас зовут?'
    name = gets.chomp.capitalize
    new_game(name)
  rescue RuntimeError => e
    puts e.inspect
    retry
  end

  def game_result(user, dealer)
    message_max(user, dealer)
    puts 'Ваши карты:'
    user.show_all_cards
    puts 'Карты дилера:'
    dealer.show_all_cards
  end

  def result_bankroll(user, dealer)
    puts "На Вашем счету $#{user.bankroll}"
    puts "На счету дилера $#{dealer.bankroll}\n\n"
  end

  def winner_user(user, dealer)
    user.bankroll += BID
    dealer.bankroll -= BID
  end

  def winner_dealer(user, dealer)
    user.bankroll -= BID
    dealer.bankroll += BID
  end

  def winner_dealer_(user, dealer)
    puts 'У вас больше 21. Дилер победил!'
    winner_dealer(user, dealer)
  end

  def winner_user_(user, dealer)
    puts 'У дилера больше 21. Вы победили!'
    winner_user(user, dealer)
  end

  def result_total(user, dealer)
    if user.total > dealer.total
      puts 'Вы выйграли!'
      winner_user(user, dealer)

    elsif user.total < dealer.total
      puts 'Дилер победил!'
      winner_dealer(user, dealer)
    else
      puts 'Ничья!'
    end
  end

  def winner(user, dealer)
    if user.total <= BLACKJACK && dealer.total <= BLACKJACK
      result_total(user, dealer)

    elsif user.total > BLACKJACK && dealer.total <= BLACKJACK
      winner_dealer_(user, dealer)

    elsif user.total <= BLACKJACK && dealer.total > BLACKJACK
      winner_user_(user, dealer)
    else
      puts 'Ничья!'
    end
  end

  def clear_hand(user, dealer)
    puts `clear`
    user.clear_player
    dealer.clear_player
  end

  def message_max(user, dealer)
    return unless user.hand.length == MAX_CARDS && dealer.hand.length == MAX_CARDS

    puts('Игроки имеют на руках максимальное количество карт. Карты открываются.')
  end

  def new_game(name)
    # create a deck of cards
    user = Player.new name, [], INITIAL_MONEY, 0
    puts "#{name}, играем в Blackjack?\n1. Да\n2. Нет\n"
    dealer = Player.new 'Дилер', [], INITIAL_MONEY, 0
    deck = Deck.new
    case_answer(user, dealer, deck)
  end

  def case_answer(user, dealer, deck)
    loop do
      answer = gets.chomp.to_i
      case answer
      when 1
        clear_hand(user, dealer)
        new_game = Blackjack.new user, dealer, deck
        new_game.menu(user, dealer, deck)
        game_result(user, dealer)
      else
        puts 'Приходите ещё!'
        break
      end

      winner(user, dealer)
      result_bankroll(user, dealer)

      if user.bankroll <= 0
        puts 'У Вас закончились деньги... '
        break
      elsif dealer.bankroll <= 0
        puts 'У Дилера закончились деньги... '
        break
      else
        puts "Поиграем ещё?\n1. Да\n2. Нет\n"
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
