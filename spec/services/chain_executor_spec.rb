require "rails_helper"

RSpec.describe ChainExecutor do
  describe ".call" do
    context "正常なチェインの場合" do
      it "成功結果とステップ情報を返すこと" do
        result = described_class.call(
          receiver_id: "r_hello_world",
          method_entries: %w[m_split m_join]
        )

        expect(result[:success]).to be true
        expect(result[:final_result][:class_name]).to eq "String"
        expect(result[:steps].size).to eq 2
        expect(result[:steps][0][:method]).to eq ".split"
        expect(result[:steps][1][:method]).to eq ".join"
      end
    end

    context "途中でエラーが発生するチェインの場合" do
      it "エラーステップと成功したステップを返すこと" do
        result = described_class.call(
          receiver_id: "r_hello_world",
          method_entries: %w[m_split m_digits]
        )

        expect(result[:success]).to be false
        expect(result[:error_at_step]).to eq 2
        expect(result[:error_message]).to match(/NoMethodError/)
        expect(result[:steps].size).to eq 1
      end
    end

    context "切り札 + Proc引数の場合" do
      it ".map(&:size) のようなチェインが実行できること" do
        result = described_class.call(
          receiver_id: "r_string_array",
          method_entries: [{ "wild" => "m_map", "proc" => "m_size" }]
        )

        expect(result[:success]).to be true
        expect(result[:final_result][:class_name]).to eq "Array"
        expect(result[:steps][0][:method]).to eq ".map(&:size)"
      end
    end

    context "メソッドリストが空の場合" do
      it "空の結果を返すこと" do
        result = described_class.call(
          receiver_id: "r_hello_world",
          method_entries: []
        )

        expect(result[:success]).to be true
        expect(result[:final_result]).to be_nil
        expect(result[:steps]).to be_empty
      end
    end

    context "ジェネレーターカードの場合" do
      it "固定引数付きメソッドが実行できること" do
        result = described_class.call(
          receiver_id: "r_nested_array",
          method_entries: %w[m_flatten m_concat_array]
        )

        expect(result[:success]).to be true
        expect(result[:final_result][:class_name]).to eq "Array"
      end
    end

    context "Hashレシーバーの場合" do
      it ".keys が実行できること" do
        result = described_class.call(
          receiver_id: "r_date_hash",
          method_entries: %w[m_keys]
        )

        expect(result[:success]).to be true
        expect(result[:final_result][:class_name]).to eq "Array"
      end
    end
  end
end
