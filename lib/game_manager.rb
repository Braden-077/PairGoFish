# frozen_string_literal: true 

require_relative 'game'

class GameManager

  attr_accessor :game, :sockets, :names
  def initialize(sockets: [], names: [])
    @sockets = sockets
    @names = names
    @players = convert_to_players(names)
    @game = Game.new(players: @players)
  end

  def start
    game.start
  end

  def convert_to_players(names)
    names.map {|name| Player.new(name: name)}
  end
end