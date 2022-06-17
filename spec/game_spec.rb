# frozen_string_literal: true

require 'game'

describe 'Game' do
  describe '#initialize' do
    it 'initializes with default paramaters' do
      game = Game.new
      expect(game.players).to eq []
      expect(game.deck.cards_left).to eq 52
      expect(game.started_status).to eq false
    end

    it 'initializes with given paramaters' do
      player = player('Josh')
      game = Game.new(players: [player], deck: Deck.new([card('A', 'S')]), started_status: true)
      expect(game.players).to eq [player]
      expect(game.deck.cards).to eq [card('A', 'S')]
      expect(game.started_status).to be true
    end
  end

  describe '#start' do
    it 'deals cards' do
      player1 = player('Josh')
      player2 = player('Will')
      player3 = player('Braden')
      game = Game.new(players: [player1, player2, player3], started_status: false)
      hand_count = game.determined_card_num
      game.start
      expect(player1.hand.count).to eq hand_count
      expect(player2.hand.count).to eq hand_count
      expect(player3.hand.count).to eq hand_count
      expect(game.deck.cards_left).to eq Deck.new.cards_left - hand_count * game.players.count
      expect(game.started_status).to be true
    end

    it 'deals 5 cards to 4 or more players' do
      players = [player('Josh'), player('Will'), player('Braden'), player('Caleb')]
      game = Game.new(players: players, started_status: false)
      hand_count = game.determined_card_num
      game.start
      expect(player1.hand.count).to eq hand_count
      expect(player2.hand.count).to eq hand_count
      expect(player3.hand.count).to eq hand_count
      expect(game.deck.cards_left).to eq Deck.new.cards_left - hand_count * game.players.count
      expect(game.started_status).to be true
    end
  end
  describe '#play_round' do
    it 'has player ask for a card and receive it' do
      players = [Player.new(name: 'Braden', hand: [card('A', 'H')]), Player.new(name: 'Josh', hand: [card('A', 'S')])]
      game = Game.new(players: players, started_status: true)
      game.play_round('A', 'Josh')
      expect(players[0].hand).to eq [card('A', 'H'), card('A', 'S')]
      expect(players[1].hand).to be_empty
      expect(game.round_count).to eq 1
    end

    it 'has player ask for a card and doesn\'t receive it, and receives the correct rank from the deck' do
      players = [Player.new(name: 'Braden', hand: [card('A', 'H')]), Player.new(name: 'Josh', hand: [card('2', 'S')])]
      game = Game.new(players: players, started_status: true, deck: Deck.new([card('A', 'C')]))
      game.play_round('A', 'Josh')
      expect(players[0].hand).to eq [card('A', 'H'), card('A', 'C')]
      expect(players[1].hand).to eq [card('2', 'S')]
      expect(game.round_count).to eq 1
    end

    it 'has player ask for a card and doesn\'t receive it, and doesn\'t receive the correct rank from the deck' do
      players = [Player.new(name: 'Braden', hand: [card('A', 'H')]), Player.new(name: 'Josh', hand: [card('2', 'S')])]
      game = Game.new(players: players, started_status: true, deck: Deck.new([card('3', 'C')]))
      game.play_round('A', 'Josh')
      expect(players[0].hand).to eq [card('A', 'H'), card('3', 'C')]
      expect(players[1].hand).to eq [card('2', 'S')]
      expect(game.round_count).to eq 2
    end

    # Hell starts here...
  end

  describe '#check_emptiness' do
    it 'checks to see if the player\'s hand is empty and has them draw a card' do
      players = [Player.new(name: 'Braden'), Player.new(name: 'Josh')]
      game = Game.new(players: players, started_status: true)
      expect(players[0].hand).to be_empty
      game.check_emptiness
      expect(players[0].hand_count).to eq 1
      expect(players[0].hand).to eq [card('2', 'C')]
    end

    it 'ups the round if the turn_player\'s hand and the deck are empty' do
      players = [Player.new(name: 'Braden'), Player.new(name: 'Josh', hand: [card('A', 'S')])]
      game = Game.new(players: players, started_status: true, deck: Deck.new([]))
      game.check_emptiness
      expect(players[0].hand).to be_empty
      expect(game.round_count).to eq 2
      expect(game.turn_player.name).to eq 'Josh'
    end
  end

  describe '#up_round' do
    it 'ups a round properly' do
      game = Game.new
      expect(game.round_count).to eq 1
      game.up_round
      expect(game.round_count).to eq 2
    end
  end

  describe '#turn_player' do
    it 'returns the proper turn player' do
      game = Game.new(players: [player('Josh'), player('Braden')], started_status: true)
      expect(game.turn_player.name).to eq 'Josh'
      game.up_round
      expect(game.turn_player.name).to eq 'Braden'
    end
  end

  describe '#go_fish' do
    it 'has a player draw a card from the deck when told to go fish' do
      game = Game.new(players: [Player.new('Braden')], started_status: true)
      expect(game.players[0].hand).to be_empty
      expect
    end
  end

  def card(rank, suit)
    Card.new(rank, suit)
  end

  def player(name, hand = [], books = [])
    Player.new(name: name, hand: hand, books: books)
  end
end
