require "rails_helper"

RSpec.describe "ゲーム作成", type: :system do
  before do
    visit root_path
  end

  it "トップページにゲーム作成フォームが表示されること" do
    expect(page).to have_content("Ruby Chains")
    expect(page).to have_button("ゲーム開始")
  end

  it "デフォルト設定でゲームを開始できること" do
    click_button "ゲーム開始"

    expect(page).to have_current_path(game_path(Game.last))
    expect(page).to have_content("プレイヤー1")
    expect(page).to have_content("プレイヤー2")
  end

  it "プレイヤー名を指定してゲームを開始できること" do
    fill_in "player_names[0]", with: "太郎"
    fill_in "player_names[1]", with: "花子"
    click_button "ゲーム開始"

    expect(page).to have_content("太郎")
    expect(page).to have_content("花子")
  end

  it "3人プレイヤーでゲームを開始できること" do
    find("[data-count='3']").click
    click_button "ゲーム開始"

    expect(page).to have_content("プレイヤー1")
    expect(page).to have_content("プレイヤー2")
    expect(page).to have_content("プレイヤー3")
  end
end
