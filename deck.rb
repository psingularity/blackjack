# frozen_string_literal: true

class Deck
  # rubocop:disable Metrics/MethodLength
  def initialize
    @faces = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A']
    @suits = ['♦ ', '♠ ', '♥ ', '♣ ']
    @cards = []

    # create deck
    @faces.each do |face|
      value = if face.instance_of?(Integer)
                face
              elsif face == 'A'
                11
              else
                10
              end
      @suits.each do |suit|
        @cards << Card.new(face, suit, value)
      end
    end
    @cards.shuffle!
  end

  # rubocop:enable Metrics/MethodLength
  def deal(num, player)
    num.times { @cards.shift.generate_card(player) }
  end
end
