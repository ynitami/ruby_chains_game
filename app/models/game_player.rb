class GamePlayer < ApplicationRecord
  belongs_to :game, inverse_of: :game_players

  validates :position, presence: true,
                       inclusion: { in: 1..4 },
                       uniqueness: { scope: :game_id }
  validates :name, presence: true
  validates :lp, numericality: { only_integer: true }
  validates :kp, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }

  COUNTER_FIELDS = %w[lp kp].freeze

  def defeated?
    lp <= 0
  end

  def increment_counter(field, delta)
    raise ArgumentError, "Invalid field: #{field}" unless COUNTER_FIELDS.include?(field)
    raise ArgumentError, "Delta must be 1 or -1" unless delta.abs == 1

    current_value = (field == "lp") ? lp : kp
    update(field => current_value + delta)
  end
end
