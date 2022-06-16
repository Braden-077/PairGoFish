# frozen_string_literal: true 
class Player
  attr_accessor :name, :hand, :books
  def initialize(name: '', hand: [], books: [])
    @name = name
    @hand = hand
    @books = books
  end

  def take_cards(cards)
    hand.push(cards).flatten!
  end

  def check_for_card(rank)
    hand.any? {|card| card.same_rank?(rank)}
  end

  def give_cards(rank)
    cards_to_give = hand.filter {|card| card.same_rank?(rank)}
    hand.delete_if {|card| cards_to_give.include?(card)}
    cards_to_give
  end

  def check_for_books(rank)
    cards_to_check = hand.filter {|card| card.same_rank?(rank)}
    if cards_to_check.length == 4
      hand.delete_if {|card| cards_to_check.count == 4 }
      books.push(cards_to_check.first.rank)
    end
  end

  def sort_hand
    hand.sort!.delete_if {|card| card.nil?}
  end
end