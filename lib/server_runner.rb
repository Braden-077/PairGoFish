# frozen_string_literal: true 

require 'pry'
require_relative 'server'

server = Server.new
server.start

while true do
  begin
    server.accept_new_client
    server.get_player_name
    server.create_game_if_possible
    if server.games.count == 1
      server.games[0].run_game
    end
  rescue
    server.stop
  end
end