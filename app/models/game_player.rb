class GamePlayer < ApplicationRecord
  belongs_to :game, inverse_of: :game_players

  validates :position, presence: true,
                       inclusion: { in: 1..4 },
                       uniqueness: { scope: :game_id }
  validates :name, presence: true
  validates :lp, numericality: { only_integer: true }
  validates :kp, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }

  def defeated?
    lp <= 0
  end
end
