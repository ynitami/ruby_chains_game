require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  test "GET new (root)" do
    get root_path
    assert_response :success
    assert_select "h1", /Ruby Chains/
  end

  test "POST create with valid params" do
    assert_difference "Game.count" do
      post games_path, params: {
        player_count: 2,
        initial_lp: 10,
        player_names: { "0" => "Alice", "1" => "Bob" }
      }
    end
    assert_redirected_to game_path(Game.last)
    assert_equal 2, Game.last.game_players.count
  end

  test "POST create uses default names when blank" do
    post games_path, params: { player_count: 3, initial_lp: 8, player_names: {} }
    game = Game.last
    assert_equal ["プレイヤー1", "プレイヤー2", "プレイヤー3"], game.game_players.map(&:name)
    assert game.game_players.all? { |p| p.lp == 8 }
  end

  test "GET show" do
    game = create_game
    get game_path(game)
    assert_response :success
  end

  test "POST execute with valid chain" do
    game = create_game
    post execute_game_path(game),
      params: { receiver_id: "r_hello_world", method_entries: ["m_split", "m_join"] },
      as: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert json["success"]
    assert_equal "String", json["final_result"]["class_name"]
  end

  test "POST execute with invalid receiver returns bad_request" do
    game = create_game
    post execute_game_path(game),
      params: { receiver_id: "r_invalid", method_entries: ["m_split"] },
      as: :json
    assert_response :bad_request
  end

  test "POST execute with invalid method returns bad_request" do
    game = create_game
    post execute_game_path(game),
      params: { receiver_id: "r_hello_world", method_entries: ["m_hacked"] },
      as: :json
    assert_response :bad_request
  end

  test "POST execute with wild card and proc" do
    game = create_game
    post execute_game_path(game),
      params: {
        receiver_id: "r_string_array",
        method_entries: [{ wild: "m_map", proc: "m_upcase" }]
      },
      as: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert json["success"]
  end

  private

  def create_game
    game = Game.new
    game.game_players.build(position: 1, name: "Alice")
    game.game_players.build(position: 2, name: "Bob")
    game.save!
    game
  end
end
