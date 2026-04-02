class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    @game = Game.new
    player_count = params[:player_count].to_i.clamp(2, 4)
    initial_lp = params[:initial_lp].to_i.clamp(8, 12)

    player_count.times do |i|
      name = params.dig(:player_names, i.to_s).presence || "プレイヤー#{i + 1}"
      @game.game_players.build(position: i + 1, name: name, lp: initial_lp, kp: 5)
    end

    if @game.save
      redirect_to game_path(@game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @game = Game.find(params[:id])
    @receiver_cards = CardData::ReceiverCard.all
    @method_cards_by_category = CardData::MethodCard.all.group_by(&:category)
    @wild_cards = CardData::MethodCard.wild_cards
    @proc_compatible_cards = CardData::MethodCard.proc_compatible_cards
  end

  def execute
    @game = Game.find(params[:id])

    receiver_id = params[:receiver_id]
    method_entries = parse_method_entries(params[:method_entries])

    unless CardData::ReceiverCard.valid_id?(receiver_id)
      return render json: { success: false, error_message: "不正なレシーバーカードです" }, status: :bad_request
    end

    unless valid_method_entries?(method_entries)
      return render json: { success: false, error_message: "不正なメソッドカードが含まれています" }, status: :bad_request
    end

    result = ChainExecutor.call(receiver_id: receiver_id, method_entries: method_entries)
    render json: result
  end

  private

  def parse_method_entries(entries)
    return [] if entries.blank?

    entries.map do |entry|
      if entry.is_a?(ActionController::Parameters) || entry.is_a?(Hash)
        entry.to_unsafe_h.stringify_keys
      else
        entry.to_s
      end
    end
  end

  def valid_method_entries?(entries)
    entries.all? do |entry|
      if entry.is_a?(Hash)
        CardData::MethodCard.valid_id?(entry["wild"]) && CardData::MethodCard.valid_id?(entry["proc"])
      else
        CardData::MethodCard.valid_id?(entry)
      end
    end
  end
end
