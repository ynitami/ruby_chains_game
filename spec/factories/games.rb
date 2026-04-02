FactoryBot.define do
  factory :game do
    after(:build) do |game|
      if game.game_players.empty?
        game.game_players.build(position: 1, name: "Alice", lp: 10, kp: 5)
        game.game_players.build(position: 2, name: "Bob", lp: 10, kp: 5)
      end
    end
  end

  factory :game_player do
    game
    sequence(:position) { |n| n }
    name { "プレイヤー#{position}" }
    lp { 10 }
    kp { 5 }
  end
end
