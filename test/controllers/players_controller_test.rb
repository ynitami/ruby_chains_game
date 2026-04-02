require "test_helper"

class PlayersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game = Game.new
    @game.game_players.build(position: 1, name: "Alice", lp: 10, kp: 5)
    @game.game_players.build(position: 2, name: "Bob", lp: 10, kp: 5)
    @game.save!
    @player = @game.game_players.first
  end

  test "PATCH update_counter increments lp" do
    patch update_counter_game_player_path(@game, @player), params: { field: "lp", delta: 1 }
    assert_response :success
    assert_equal 11, @player.reload.lp
  end

  test "PATCH update_counter decrements kp" do
    patch update_counter_game_player_path(@game, @player), params: { field: "kp", delta: -1 }
    assert_response :success
    assert_equal 4, @player.reload.kp
  end

  test "PATCH update_counter rejects invalid field" do
    patch update_counter_game_player_path(@game, @player), params: { field: "name", delta: 1 }
    assert_response :bad_request
  end

  test "PATCH update_counter rejects large delta" do
    patch update_counter_game_player_path(@game, @player), params: { field: "lp", delta: 5 }
    assert_response :bad_request
  end
end
