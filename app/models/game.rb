class Game < ApplicationRecord
  has_many :game_players, -> { order(:position) }, dependent: :destroy, inverse_of: :game
  accepts_nested_attributes_for :game_players

  validates :game_players, length: { minimum: 2, maximum: 4, message: "は2〜4人で設定してください" }
end
