require "rails_helper"

RSpec.describe Game do
  describe "プレイヤー人数のバリデーション" do
    context "2人の場合" do
      it "有効であること" do
        game = build(:game)

        expect(game).to be_valid
      end
    end

    context "1人の場合" do
      it "無効であること" do
        game = Game.new
        game.game_players.build(position: 1, name: "Alice")

        expect(game).not_to be_valid
      end
    end

    context "5人の場合" do
      it "無効であること" do
        game = Game.new
        5.times { |i| game.game_players.build(position: i + 1, name: "P#{i + 1}") }

        expect(game).not_to be_valid
      end
    end
  end

  describe "dependent: :destroy" do
    it "ゲーム削除時にプレイヤーも削除されること" do
      game = create(:game)

      expect { game.destroy! }.to change(GamePlayer, :count).by(-2)
    end
  end
end
