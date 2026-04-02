class GamesController < ApplicationController
  before_action :set_game, only: :show

  def new
    @game = Game.new
  end

  def create
    @game = Game.build_with_players(
      player_count: params[:player_count].to_i,
      initial_lp: params[:initial_lp].to_i,
      player_names: params[:player_names] || {}
    )

    if @game.save
      redirect_to game_path(@game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end
end
