require "rails_helper"

RSpec.describe "LP/KPカウンター", type: :system do
  let!(:game) { create(:game) }
  let(:player) { game.game_players.first }

  before do
    visit game_path(game)
  end

  it "data-controller='counter' が各プレイヤーに存在すること" do
    within("#player_counter_#{player.id}") do
      expect(page).to have_css("[data-controller='counter']")
    end
  end

  describe "LPカウンター" do
    it "+ボタンでLPが1増えること" do
      container = find("#player_counter_#{player.id}")
      container.find("[data-field='lp'][data-action*='increment']").click

      expect(container).to have_text("11")
    end

    it "-ボタンでLPが1減ること" do
      container = find("#player_counter_#{player.id}")
      container.find("[data-field='lp'][data-action*='decrement']").click

      expect(container).to have_text("9")
    end
  end

  describe "KPカウンター" do
    it "-ボタンでKPが1減ること" do
      container = find("#player_counter_#{player.id}")
      container.find("[data-field='kp'][data-action*='decrement']").click

      expect(container).to have_text("4")
    end

    it "上限5を超えないこと" do
      container = find("#player_counter_#{player.id}")
      container.find("[data-field='kp'][data-action*='increment']").click

      # KP初期値5、上限5なのでバリデーションエラーで値は変わらない
      expect(container).to have_text("5")
    end
  end
end
