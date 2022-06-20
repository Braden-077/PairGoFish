# frozen_string_literal: true 

require 'socket'
require 'pry'
require_relative 'client'

client = Client.new(3000)
while true do
  message = client.read_from_server
  client.print_message(message)
  if client.requires_input?(message)
    input = gets
    client.send_to_server(input)
  end
end