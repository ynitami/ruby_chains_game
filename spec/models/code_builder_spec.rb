require "rails_helper"

RSpec.describe CodeBuilder do
  describe "#full_chain_code" do
    it "シンプルなチェインを組み立てられること" do
      builder = described_class.new(
        receiver_id: "r_hello_world",
        method_entries: %w[m_split m_join]
      )

      expect(builder.full_chain_code).to eq '" Hello World ".split.join'
    end

    it "切り札 + Proc引数のチェインを組み立てられること" do
      builder = described_class.new(
        receiver_id: "r_string_array",
        method_entries: [{ "wild" => "m_map", "proc" => "m_to_s" }]
      )

      expect(builder.full_chain_code).to eq '["Method", "Class", "Object", "Method"].map(&:to_s)'
    end

    context "存在しないカードIDの場合" do
      it "ArgumentErrorが発生すること" do
        builder = described_class.new(
          receiver_id: "r_hello_world",
          method_entries: ["m_fake"]
        )

        expect { builder.full_chain_code }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#code_up_to_step" do
    it "指定ステップまでの部分チェインを返すこと" do
      builder = described_class.new(
        receiver_id: "r_hello_world",
        method_entries: %w[m_split m_size]
      )

      expect(builder.code_up_to_step(0)).to eq '" Hello World ".split'
      expect(builder.code_up_to_step(1)).to eq '" Hello World ".split.size'
    end
  end

  describe "#step_labels" do
    it "各ステップの表示名を返すこと" do
      builder = described_class.new(
        receiver_id: "r_hello_world",
        method_entries: ["m_split", { "wild" => "m_map", "proc" => "m_upcase" }, "m_join"]
      )

      expect(builder.step_labels).to eq [".split", ".map(&:upcase)", ".join"]
    end
  end
end
