require "test_helper"

class GamePlayerTest < ActiveSupport::TestCase
  setup do
    @game = Game.new
    @game.game_players.build(position: 1, name: "Alice", lp: 10, kp: 5)
    @game.game_players.build(position: 2, name: "Bob", lp: 10, kp: 5)
    @game.save!
  end

  test "valid player" do
    assert @game.game_players.first.valid?
  end

  test "position must be 1-4" do
    player = @game.game_players.build(position: 5, name: "X")
    assert_not player.valid?
  end

  test "position must be unique within game" do
    player = @game.game_players.build(position: 1, name: "Dup")
    assert_not player.valid?
  end

  test "name is required" do
    player = @game.game_players.build(position: 3, name: "")
    assert_not player.valid?
  end

  test "kp cannot exceed 5" do
    player = @game.game_players.first
    player.kp = 6
    assert_not player.valid?
  end

  test "defeated? when lp <= 0" do
    player = @game.game_players.first
    player.lp = 0
    assert player.defeated?
    player.lp = -1
    assert player.defeated?
  end

  test "not defeated? when lp > 0" do
    player = @game.game_players.first
    assert_not player.defeated?
  end
end
