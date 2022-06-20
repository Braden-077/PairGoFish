# frozen_string_literal: true 

require 'pry'
require_relative 'server'

server = Server.new
server.start

while true do
  begin
    server.accept_new_client
    server.get_player_name
    server.create_game_manager_if_possible
    if server.game_managers.count == 1
      server.game_managers.first.run_game
    end
  rescue
    server.stop
    break
  end
end