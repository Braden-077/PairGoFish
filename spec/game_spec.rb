# frozen_string_literal: true

require 'game'
require 'deck'
require 'player'

describe 'Game' do
  describe '#initialize' do
    it 'initializes with default paramaters' do
      game = Game.new
      expect(game.players).to eq []
      expect(game.deck.cards_left).to eq 52
      expect(game.started_status).to eq false
    end

    it 'initializes with given paramaters' do
      player = Player.new(name: 'Josh')
      game = Game.new(players: [player], deck: Deck.new([Card.new('A', 'S')]), started_status: true)
      expect(game.players).to eq [player]
      expect(game.deck.cards).to eq [Card.new('A', 'S')]
      expect(game.started_status).to be true
    end
  end

  describe '#start' do
    it 'deals cards' do
      player1 = Player.new(name: 'Josh')
      player2 = Player.new(name: 'Will')
      player3 = Player.new(name: 'Braden')
      game = Game.new(players: [player1, player2, player3], started_status: false)
      hand_count = game.determined_card_num
      game.start
      game.players.each {|player| expect(player.hand_count).to eq hand_count}
      expect(game.deck.cards_left).to eq Deck.new.cards_left - hand_count * game.players.count
      expect(game.started_status).to be true
    end

    it 'deals 5 cards to 4 or more players' do
      players = [Player.new(name: 'Josh'), Player.new(name: 'Will'), Player.new(name: 'Braden'), Player.new(name: 'Caleb')]
      game = Game.new(players: players, started_status: false)
      hand_count = game.determined_card_num
      game.start
      expect(players[0].hand.count).to eq hand_count
      expect(players[1].hand.count).to eq hand_count
      expect(players[2].hand.count).to eq hand_count
      expect(game.deck.cards_left).to eq Deck.new.cards_left - hand_count * game.players.count
      expect(game.started_status).to be true
    end
  end

  describe '#play_round' do
    it 'has player ask for a card and receive it' do
      players = [Player.new(name: 'Braden', hand: [Card.new('A', 'H')]), Player.new(name: 'Josh', hand: [Card.new('A', 'S')])]
      game = Game.new(players: players, started_status: true)
      game.play_round('A', game.get_player('Josh'))
      expect(players[0].hand).to eq [Card.new('A', 'H'), Card.new('A', 'S')]
      expect(players[1].hand).to be_empty
      expect(game.round_count).to eq 1
    end

    it 'has player ask for a card and doesn\'t receive it, and receives the correct rank from the deck' do
      players = [Player.new(name: 'Braden', hand: [Card.new('A', 'H')]), Player.new(name: 'Josh', hand: [Card.new('2', 'S')])]
      game = Game.new(players: players, started_status: true, deck: Deck.new([Card.new('A', 'C')]))
      game.play_round('A', game.get_player('Josh'))
      expect(players[0].hand).to eq [Card.new('A', 'H'), Card.new('A', 'C')]
      expect(players[1].hand).to eq [Card.new('2', 'S')]
      expect(game.round_count).to eq 1
    end

    it 'has player ask for a card and doesn\'t receive it, and doesn\'t receive the correct rank from the deck' do
      players = [Player.new(name: 'Braden', hand: [Card.new('A', 'H')]), Player.new(name: 'Josh', hand: [Card.new('2', 'S')])]
      game = Game.new(players: players, started_status: true, deck: Deck.new([Card.new('3', 'C')]))
      game.play_round('A', game.get_player('Josh'))
      expect(players[0].hand).to eq [Card.new('A', 'H'), Card.new('3', 'C')]
      expect(players[1].hand).to eq [Card.new('2', 'S')]
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
      expect(players[0].hand).to eq [Card.new('2', 'C')]
    end

    it 'ups the round if the turn_player\'s hand and the deck are empty' do
      players = [Player.new(name: 'Braden'), Player.new(name: 'Josh', hand: [Card.new('A', 'S')])]
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
      game = Game.new(players: [Player.new(name: 'Josh'), Player.new(name: 'Braden')], started_status: true)
      expect(game.turn_player.name).to eq 'Josh'
      game.up_round
      expect(game.turn_player.name).to eq 'Braden'
    end
  end

  describe '#go_fish' do
    it 'has a player draw a card from the deck when told to go fish' do
      game = Game.new(players: [Player.new(name: 'Braden')], started_status: true)
      expect(game.players[0].hand).to be_empty
      game.go_fish(game.turn_player)
      expect(game.players[0].hand_count).to eq 1
    end
  end

  describe '#over?' do
    it 'returns false when all 13 books have been collected' do
      game = Game.new(players: [Player.new(name: 'Josh', books: %w(2 3 4 5 6 7 8 9 10)), Player.new(name: 'Braden', books: %w(J Q K A))])
      expect(game.over?).to be true
    end
  end
end
