# frozen_string_literal: true

require_relative 'constant_values'

class Blackjack
  attr_accessor :user, :dealer, :deck

  include ConstantValues

  def initialize(user, dealer, deck)
    puts "#{user.name}, подождите немного..."
    puts "Банк дилера: #{dealer.bankroll}$"
    puts "Ваш банк: #{user.bankroll}$"
    first_step(user, dealer, deck)
    info_menu
  end

  def info_menu
    puts 'Ваш ход:'
    puts "1. Пропустить ход.\n2. Добавить карту.\n3. Открыть карты."
  end

  def first_step(user, dealer, deck)
    first_step_human(user, deck)
    first_step_computer(dealer, deck)
  end

  def open_auto(user, dealer)
    user.hand.length == MAX_CARDS && dealer.hand.length == MAX_CARDS
  end

  def skip_user(user, dealer, deck)
    if user.hand.length == MAX_CARDS
      user.skip
    else
      game_user(user, dealer, deck)
      skip_dealer(user, dealer, deck) unless open_auto(user, dealer)
    end
  end

  def skip_dealer(user, dealer, deck)
    if dealer.hand.length == MAX_CARDS
      dealer.skip
    else
      game_dealer(user, dealer, deck)
    end
  end

  def menu(user, dealer, deck)
    until user.bankroll.zero? || open_auto(user, dealer)
      choice = gets.chomp.to_i
      case choice
      when 1 then (open_auto(user, dealer) ? break : skip_dealer(user, dealer, deck))
      when 2 then (open_auto(user, dealer) ? break : skip_user(user, dealer, deck))
      else
        break
      end
    end
  end

  def first_step_human(user, deck)
    puts 'Ваши карты:'
    deck.deal(2, user)
    user.ace
    user.show_all_cards
  end

  def first_step_computer(dealer, deck)
    puts 'Kарты дилера:'
    deck.deal(2, dealer)
    dealer.ace
    puts '* *'
    dealer.show_all_cards
  end

  def game_dealer(user, dealer, deck)
    puts 'Ход дилера...'
    sleep 2
    # dealer has 17
    if dealer.total >= DEALER_POINT
      puts 'Дилер пропускает ход.'
    else
      deck.deal(1, dealer)
      dealer.ace
      puts('Дилер достает карту: *')
    end
    info_menu unless open_auto(user, dealer)
  end

  def game_user(user, _dealer, deck)
    deck.deal(1, user)
    puts 'Выпала карта:'
    user.show_card
    user.ace
    puts "Количество очков: #{user.total}"
  end
end
