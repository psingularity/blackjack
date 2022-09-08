# frozen_string_literal: true

class Blackjack
  attr_accessor :user, :dealer, :deck

  def initialize(user, dealer, deck)
    puts "#{user.name}, подождите немного. Зачисляются деньги ..."
    sleep 1
    puts "Банк дилера: #{dealer.bankroll}$"
    puts "Ваш банк: #{user.bankroll}$"
    sleep 1
    first_step_human(user, deck)
    first_step_computer(dealer, deck)
  end

  def menu(user, dealer, deck)
    puts "1. Пропустить ход.\n2. Добавить карту.\n3. Открыть карты."
    until user.bankroll.zero?

      choice = gets.chomp.to_i
      case choice
      when 1
        # game dealer
        game_dealer(dealer, user, deck)
      when 2
        game_user(user, dealer, deck)
      when 3
        puts `clear`
        cards_players(user, dealer)
        break
      else
        break
      end
    end
  end

  def first_step_human(user, deck)
    puts 'Ваши карты:'
    deck.deal(2, user)
    user.show_all_cards

    if (user.hand[1].face == 'A' && user.total > BLACKJACK) || (user.hand[0].face == 'A' && user.total > BLACKJACK)
      user.total -= BID
    end

    puts "Количество очков: #{user.total}"
  end

  def first_step_computer(dealer, deck)
    puts 'Kарты дилера:'
    deck.deal(2, dealer)
    dealer.show_all_cards
    if (dealer.hand[1].face == 'A' && dealer.total > BLACKJACK) || (dealer.hand[0].face == 'A' && dealer.total > BLACKJACK)
      dealer.total -= BID
    end
    puts "Количество очков: #{dealer.total}"
  end

  def game_dealer(dealer, user, deck)
    puts 'Ход дилера...'
    sleep 3
    dealer.ace
    if dealer.total >= DEALER_POINT && dealer.total != BLACKJACK
      puts "Дилер пропускает ход.\nВаш ход:"

    else

      if dealer.hand.length < 3 && dealer.total != BLACKJACK
        deck.deal(1, dealer)
        puts('Дилер достает карту:')
        dealer.show_card
        puts "Количество очков: #{dealer.total}"
      else
        puts('У дилера уже максимальное количество карт(3), он пропускает ход.')
      end
      sleep 3
      puts 'Ваш ход:'
    end
    if user.hand.length < 3
      puts "1. Пропустить ход.\n2. Добавить карту.\n3. Открыть карты."
    else
      puts "У Вас на руках уже максимальное количество карт(3).\n1. Пропустить ход.\n3. Открыть карты."
    end
  end

  def game_user(user, dealer, deck)
    deck.deal(1, user)
    puts 'Выпала карта:'
    user.show_card
    user.ace
    puts "Количество очков: #{user.total}"
    game_dealer(dealer, user, deck)
  end

  def cards_players(user, dealer)
    puts 'Ваши карты:'
    user.show_all_cards
    puts 'Карты дилера:'
    dealer.show_all_cards
  end
end
