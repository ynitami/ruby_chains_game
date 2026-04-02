class Games::Players::CountersController < ApplicationController
  before_action :set_player

  def update
    if @player.increment_counter(params[:field], params[:delta].to_i)
      render partial: "games/player_counter", locals: { player: @player }
    else
      head :unprocessable_entity
    end
  rescue ArgumentError
    head :bad_request
  end

  private

  def set_player
    game = Game.find(params[:game_id])
    @player = game.game_players.find(params[:player_id])
  end
end
