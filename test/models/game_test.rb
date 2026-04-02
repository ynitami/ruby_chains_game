require "test_helper"

class GameTest < ActiveSupport::TestCase
  test "valid with 2 players" do
    game = Game.new
    game.game_players.build(position: 1, name: "Alice")
    game.game_players.build(position: 2, name: "Bob")
    assert game.valid?
  end

  test "invalid with fewer than 2 players" do
    game = Game.new
    game.game_players.build(position: 1, name: "Alice")
    assert_not game.valid?
  end

  test "invalid with more than 4 players" do
    game = Game.new
    5.times { |i| game.game_players.build(position: i + 1, name: "P#{i + 1}") }
    assert_not game.valid?
  end

  test "destroys players on destroy" do
    game = Game.new
    game.game_players.build(position: 1, name: "Alice")
    game.game_players.build(position: 2, name: "Bob")
    game.save!
    assert_difference "GamePlayer.count", -2 do
      game.destroy!
    end
  end
end
