# frozen_string_literal: true

class Player
  attr_accessor :bankroll, :hand, :total

  attr_reader :name

  def initialize(name, _hand, bankroll, total)
    @name = name
    @hand = []
    @bankroll = bankroll
    @total = total
  end

  def clear_player
    hand.clear
    self.total = 0
  end

  # checking the correct value of the ace

  def ace
    self.total -= 10 if hand[0].face == 'A' && total > BLACKJACK
  end

  def show_card
    card_face = hand[0].face
    card_suit = hand[0].suit
    puts "#{card_face} #{card_suit}"
  end

  def show_all_cards
    all_cards = []
    hand.each do |i|
      card_face = i.face
      card_suit = i.suit
      all_cards << "#{card_face}#{card_suit}"
    end
    puts all_cards.map(&:to_s).join(' ')
  end
end
