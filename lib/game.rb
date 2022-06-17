# frozen_string_literal: true 

class Game
  attr_accessor :players, :deck, :started_status, :round_count, :turn_player, :books
  def initialize(players: [], deck: Deck.new, started_status: false)
    @players = players 
    @deck = deck
    @started_status = started_status
    @books = books
    @round_count = 1
    @turn_player = turn_player
  end

  def start
    return if started_status
    deck.shuffle!
    determined_card_num.times {players.each {|player| player.take_cards(deck.deal)}}
    @started_status = true
  end

  def determined_card_num
    if players.length >= 4
      5
    elsif players.length <= 3
      7
    end
  end

    def play_round(rank, asked_player)
      return unless turn_player
      player_asked = get_player(asked_player)
      ask_for_card(rank, player_asked)
    end

    def up_round
      @round_count += 1
    end

    def ask_for_card(rank, player_asked)
      if turn_player.check_for_card(rank) && player_asked.check_for_card(rank)
        turn_player.take_cards(player_asked.give_cards(rank))
      elsif !player_asked.check_for_card(rank)
        up_round if go_fish(turn_player) != rank
      end
    end

    def turn_player
      return unless started_status
        turn = (@round_count - 1) % players.count 
        players[turn]
    end

    def go_fish(player)
      card = player.take_cards(deck.deal)
      card.rank
    end

    def get_player(name)
      players.find {|player| player.name == name}
    end

    def check_emptiness
      return unless turn_player.hand_empty?
      if deck.cards.empty?
        up_round
        check_emptiness
      else
        go_fish(turn_player)
      end
    end
end