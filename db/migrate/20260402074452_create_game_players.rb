class CreateGamePlayers < ActiveRecord::Migration[8.1]
  def change
    create_table :game_players do |t|
      t.references :game, null: false, foreign_key: true
      t.integer :position, null: false
      t.string :name, null: false
      t.integer :lp, null: false, default: 10
      t.integer :kp, null: false, default: 5

      t.timestamps
    end

    add_index :game_players, %i[game_id position], unique: true
  end
end
