# frozen_string_literal: true 

class RoundResult
  attr_accessor :asker, :rank, :target_player
  def initialize(asker:, rank:, target_player:)
    @asker = asker
    @rank = rank
    @target_player = target_player
  end
end