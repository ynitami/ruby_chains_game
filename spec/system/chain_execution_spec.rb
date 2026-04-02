require "rails_helper"

RSpec.describe "チェイン実行", type: :system do
  let!(:game) { create(:game) }

  before do
    visit game_path(game)
  end

  it "メイン画面にレシーバー選択とメソッドカード一覧が表示されること" do
    expect(page).to have_select(class: "w-full")
    expect(page).to have_content("メソッドカード")
    expect(page).to have_content("A. 主力")
  end

  it "レシーバーとメソッドを選択してチェインを実行できること" do
    # レシーバーを選択
    find("[data-chain-target='receiverSelect']").select("\" Hello World \" (String)")

    # メソッドカードをクリック
    click_button ".split"

    # 実行ボタンをクリック
    click_button "実行"

    # 結果が表示されること
    expect(page).to have_content("結果")
  end

  it "エラーが発生するチェインではエラーが表示されること" do
    find("[data-chain-target='receiverSelect']").select("\" Hello World \" (String)")

    click_button ".digits"
    click_button "実行"

    expect(page).to have_content("エラー")
  end

  it "チェイン表示からメソッドを削除できること" do
    find("[data-chain-target='receiverSelect']").select("\" Hello World \" (String)")
    click_button ".split"

    # チェイン表示内のメソッドタグをクリックして削除
    within("[data-chain-target='chainDisplay']") do
      find("button", text: ".split").click
    end

    # 実行ボタンが無効化されること（メソッドが0個）
    expect(page).to have_button("実行", disabled: true)
  end
end
