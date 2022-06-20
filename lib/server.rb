# frozen_string_literal: true

require_relative 'game_manager'
require 'socket'
require 'pry'

class Server
  attr_accessor :sockets, :games, :player_names

  def initialize
    @sockets = []
    @games = []
    @player_names = []
  end

  def port_number
    3000
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client
    socket = @server.accept
    sockets.push(socket)
    sockets.each { |socket| socket.puts 'A new challenger approaches!' }
    socket.puts "You've connected!"
    socket.puts 'Please enter your name:'
  end

  def create_game_if_possible
    if sockets.count == 2
      game = GameManager.new
      games.push(game)
      game
    end
  end

  def capture_input(socket)
    sleep(0.01)
    socket.read_nonblock(1000).chomp
  rescue IO::WaitReadable
  end

  def get_player_name
    sockets.each_with_index do |socket, index|
      next if player_names[index]

      begin
        player_names[index] = socket.gets.strip
        socket.puts 'Got name!'
      rescue IO::WaitReadable
      end
    end
  end

  def stop
    @server.close if @server
  end
end
