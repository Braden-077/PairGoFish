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
        manager = GameManager.new
        expect(manager.game.class).to eq Game
        expect(manager.game.players).to be_empty
        expect{ manager }.not_to raise_error
      end
    end
end