class PlayersController < ApplicationController
  before_action :set_player

  def update_counter
    field = params[:field]
    delta = params[:delta].to_i

    unless %w[lp kp].include?(field) && delta.abs == 1
      return head :bad_request
    end

    @player.update!(field => @player.send(field) + delta)
    render partial: "games/player_counter", locals: { player: @player }
  end

  private

  def set_player
    @game = Game.find(params[:game_id])
    @player = @game.game_players.find(params[:id])
  end
end
