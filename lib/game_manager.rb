# frozen_string_literal: true 

require_relative 'game'
require_relative 'round_result'
require_relative 'player'
require 'pry'

class GameManager
  attr_accessor :sockets, :players, :game, :associated_list, :server, :first_message_sent, :asked_player, :rank, :ask_rank_message_sent
  def initialize(sockets: [], names: [])
    @server = server
    @sockets = sockets
    @players = create_players(names)
    @game = Game.new(players: @players)
    @associated_list = associate_player_socket(sockets, @players)
    @first_message_sent = false
    @ask_rank_message_sent = false
  end

  def run_game
    until game.over?
      process_input
      # returns round result
    end
  end

  def process_input
    beginning_message unless first_message_sent
    self.asked_player ||= get_input_from_current_player
    return unless asked_player
    current_player_socket.puts "What rank would you like to ask for?" unless ask_rank_message_sent
    self.ask_rank_message_sent = true 
    self.rank ||= get_input_from_current_player
    return unless rank
    game.play_round(rank, game.get_player(asked_player))
    reset_message_status
  end

  def beginning_message
    @associated_list.each_key {|socket| socket.puts("Here's your hand!")}
    @associated_list.each_pair {|socket, player| socket.puts(player.hand.map(&:to_s))}
    current_player_socket.puts "It's your turn!\nWho would you like to ask for cards?"
    send_to_all_except_current("It's #{current_player_name}'s turn. Go #{current_player_name}!\n")
    self.first_message_sent = true 
  end

  def reset_message_status
    self.first_message_sent = false
    self.ask_rank_message_sent = false
    return_output
  end

  def return_output
    # TODO: access Round Result and print it
  end

  def get_input_from_current_player
    sleep(0.01)
    current_player_socket.read_nonblock(1000).chomp
  rescue IO::WaitReadable
  end

  def send_to_all_except_current(message)
    sockets.reject{|socket| socket == current_player_socket }.each {|socket| socket.puts(message)}
  end

  def start
    game.start 
  end

  private
  
  def current_player_socket
    @associated_list.key(game.turn_player)
  end

  def current_player_name
    game.turn_player.name
  end

  def create_players(player_names)
    player_names.map {|name| Player.new(name: name)}
  end


  def associate_player_socket(sockets, player_names)
    sockets.map.with_index { |socket, index| [socket, player_names[index]] }.to_h
  end
end