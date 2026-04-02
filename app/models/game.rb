class Game < ApplicationRecord
  has_many :game_players, -> { order(:position) }, dependent: :destroy, inverse_of: :game
  accepts_nested_attributes_for :game_players

  validates :game_players, length: { minimum: 2, maximum: 4, message: "は2〜4人で設定してください" }

  def self.build_with_players(player_count:, initial_lp:, player_names: {})
    game = new
    player_count.clamp(2, 4).times do |i|
      name = player_names[i.to_s].presence || "プレイヤー#{i + 1}"
      game.game_players.build(position: i + 1, name: name, lp: initial_lp.clamp(8, 12))
    end
    game
  end
end
