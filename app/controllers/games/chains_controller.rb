class Games::ChainsController < ApplicationController
  def create
    Game.find(params[:game_id]) # ゲーム存在確認（404用）

    method_entries = ChainExecutor.parse_params(params[:method_entries])

    if (error = ChainExecutor.validate(receiver_id: params[:receiver_id], method_entries: method_entries))
      return render json: { success: false, error_message: error }, status: :bad_request
    end

    result = ChainExecutor.call(receiver_id: params[:receiver_id], method_entries: method_entries)
    render json: result
  end
end
