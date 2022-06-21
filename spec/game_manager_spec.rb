# frozen_string_literal: true 

require 'game_manager'
require 'server'

  describe 'GameManager' do
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
  
    describe '#initialize' do
      it 'initializes without error when provided no clients or players' do
        manager = GameManager.new()
        expect(manager.sockets).to be_empty
        expect(manager.players).to be_empty
        expect(manager.game.class).to eq Game
        expect(manager.game.players).to be_empty
        expect{ manager }.not_to raise_error
      end
    
      it 'associates players and clients correctly' do
        manager = GameManager.new(sockets: [TCPSocket.new('localhost', 3000)], names: ['Braden'])
        expect(manager.sockets).to be_one
        expect(manager.players).to be_one
        expect(manager.associated_list.length).to eq(1)
      end
    end

    describe '#process_input' do
      it 'runs a round and sends the results to the players' do
        clients = setup_server_with_clients(['Caleb', 'Braden'])
        manager = @server.create_game_manager_if_possible
        manager.start
        manager.process_input
        manager.associated_list.values[0].hand = [Card.new('A', 'S')]
        manager.associated_list.values[1].hand = [Card.new('A', 'H')]
        message = clients[0].read_from_server
        expect(message).to include("It's your turn!")
        expect(message).to include("Here's your hand!")
        expect(message).to include("Who would you like to ask for cards?")
        clients[0].send_to_server('Braden')
        manager.process_input
        expect(clients[0].read_from_server).to include("What rank would you like to ask for?")
        clients[0].send_to_server('A')
        manager.process_input
        round_result = clients[0].read_from_server
        expect(round_result).to include("Caleb took A's from Braden.")
        expect(clients[1].read_from_server).to include("Caleb took your A's!")
      end
    end

    def setup_server_with_clients(player_names)
      player_names.map do |player_name|
        client = Client.new(3000)
        @server.accept_new_client
        client.send_to_server(player_name)
        @server.get_player_name
        client.read_from_server
        client
      end
    end
end