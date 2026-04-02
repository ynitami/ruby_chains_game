class Games::ChainsController < ApplicationController
  before_action :set_game

  def create
    method_entries = ChainExecutor.parse_params(params[:method_entries])

    if (error = ChainExecutor.validate(receiver_id: params[:receiver_id], method_entries: method_entries))
      return render json: { success: false, error_message: error }, status: :bad_request
    end

    result = ChainExecutor.call(receiver_id: params[:receiver_id], method_entries: method_entries)
    render json: result
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end
end
