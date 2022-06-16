# frozen_string_literal: true 

require 'player'

describe Player do
  describe '#initalize' do
    it 'initializes a player with default paramaters' do
      player = Player.new
      expect { player }.not_to raise_error
      expect(player.name).to eq ''
      expect(player.hand).to be_empty
      expect(player.books).to be_empty
    end

    it 'initializes with given paramaters' do 
      player = Player.new(name: 'Braden', hand: [card('A', 'H')], books: ['A', 'J'])
      expect(player.name).to eq 'Braden'
      expect(player.hand).to eq [card('A', 'H')]
      expect(player.books).to eq ['A', 'J']
    end
  end

  it 'takes cards' do 
    player = Player.new(name: 'Braden', hand: [card('A', 'H')])
    player.take_cards(card('A', 'S'))
    expect(player.hand).to eq [card('A', 'H'), card('A', 'S')]
  end

  it 'gives cards' do 
    player = Player.new(name: 'Braden', hand: [card('A', 'H'), card('A', 'S'), card('2', 'S')])
    cards = player.give_cards('A')
    expect(cards).to eq  [card('A', 'H'), card('A', 'S')]
    expect(player.hand).to eq [card('2', 'S')]
  end
  
  it 'check_for_books' do
     player = Player.new(name: 'Braden', hand: [card('A', 'H'), card('A', 'S'), card('A', 'D')])
     player.check_for_books('A')
     expect(player.books.count).to be 0
     player.take_cards([card('A', 'C'), card('2', 'S')])
     player.check_for_books('A')
     expect(player.books.count).to eq 1
  end

  it 'sorts the hand' do 
    player = Player.new(name: 'Braden', hand: [card('Q', 'S'), nil, nil, nil, card('2', 'H'), nil, card('7', 'D'), card('8', 'C'), nil])
    player.sort_hand
    expect(player.hand).to eq [card('2', 'H'), card('7', 'D'), card('8', 'C'), card('Q', 'S')]
  end

  it 'check_for_card' do 
    player = Player.new(name: 'Braden', hand: [card('A', 'H'), card('A', 'S'), card('A', 'D'), card('2', 'S')])
    expect(player.check_for_card('A')).to be true
    expect(player.check_for_card('2')).to be true
    expect(player.check_for_card('4')).to be false
  end

  def card(rank, suit)
    Card.new(rank, suit)
  end
end