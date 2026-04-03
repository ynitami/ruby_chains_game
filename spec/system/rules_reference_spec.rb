require "rails_helper"

RSpec.describe "ルール参照", type: :system do
  def open_rules_dialog
    find("button[aria-label='ルールを表示']").click
    expect(page).to have_css("dialog#rules-dialog[open]")
  end

  before do
    visit root_path
  end

  it "FABボタンが表示されること" do
    expect(page).to have_css("button[aria-label='ルールを表示']")
  end

  it "FABボタンをクリックするとルールダイアログが表示されること" do
    open_rules_dialog

    within "dialog#rules-dialog" do
      expect(page).to have_content("ゲームルール")
    end
  end

  it "ダイアログ内に全4タブが表示されること" do
    open_rules_dialog

    within "dialog#rules-dialog" do
      expect(page).to have_button("基本ルール")
      expect(page).to have_button("上級ルール")
      expect(page).to have_button("カードリスト")
      expect(page).to have_button("FAQ")
    end
  end

  it "初期表示で基本ルールの内容が表示されること" do
    open_rules_dialog

    within "dialog#rules-dialog" do
      expect(page).to have_content("ゲームの概要")
      expect(page).to have_content("ライフポイント（LP）")
    end
  end

  it "タブを切り替えるとコンテンツが切り替わること" do
    open_rules_dialog

    within "dialog#rules-dialog" do
      click_button "カードリスト"

      expect(page).to have_content("メソッドカード")
    end
  end

  it "閉じるボタンでダイアログが閉じること" do
    open_rules_dialog

    within "dialog#rules-dialog" do
      find("button[aria-label='閉じる']").click
    end

    expect(page).to have_no_css("dialog#rules-dialog[open]")
  end

  context "ゲーム画面" do
    let!(:game) { create(:game) }

    it "ゲーム画面にもFABボタンが表示されること" do
      visit game_path(game)

      expect(page).to have_css("button[aria-label='ルールを表示']")
    end
  end
end
