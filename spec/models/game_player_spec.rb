require "rails_helper"

RSpec.describe GamePlayer do
  let(:game) { create(:game) }
  let(:player) { game.game_players.first }

  describe "#defeated?" do
    context "LPが0以下の場合" do
      it "trueを返すこと" do
        player.lp = 0
        expect(player).to be_defeated

        player.lp = -1
        expect(player).to be_defeated
      end
    end

    context "LPが正の場合" do
      it "falseを返すこと" do
        player.lp = 1

        expect(player).not_to be_defeated
      end
    end
  end

  describe "席順の一意性" do
    it "同じゲーム内で同じ席順は無効であること" do
      duplicate = game.game_players.build(position: 1, name: "Duplicate")

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:position]).to be_present
    end
  end

  describe "KPの上限" do
    it "5を超えるKPは無効であること" do
      player.kp = 6

      expect(player).not_to be_valid
    end

    it "負のKPは無効であること" do
      player.kp = -1

      expect(player).not_to be_valid
    end
  end
end
