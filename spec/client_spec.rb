# frozen_string_literal: true

require 'client'
require 'server'

describe Client do
  before(:each) do
    @sockets = []
    @server = Server.new
    @server.start
  end

  after(:each) do
    @server.stop
    @sockets.each do |client|
      client.close
    end
  end

  describe '#read_from_server' do
    it 'reads messages from the server to the client' do
      client1 = Client.new(@server.port_number)
      @server.accept_new_client
      message = client1.read_from_server
      expect(message).to include('Please enter your name:')
    end
  end

  describe '#requires_input?' do
    it 'returns true when a message includes a colon' do
      client1 = Client.new(@server.port_number)
      @server.accept_new_client
      message = client1.read_from_server
      expect(client1.requires_input?(message)).to be true
    end
  end
end
