# frozen_string_literal: true

class Card
  attr_reader :face, :value, :suit

  def initialize(face, suit, value)
    @face = face
    @value = value
    @suit = suit
  end

  def generate_card(player)
    new_card = Card.new face, suit, value
    player.hand.prepend(new_card)
    player.total = player.total + new_card.value
  end

  def all_cards(player)
    player.hand
  end

  protected

  attr_writer :face, :value, :suit
end
