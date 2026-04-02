require "rails_helper"

RSpec.describe CardData::ReceiverCard do
  before { described_class.reload! }

  describe ".all" do
    it "10種のレシーバーカードが読み込まれること" do
      expect(described_class.all.size).to eq 10
    end
  end

  describe ".find" do
    it "IDでカードを取得できること" do
      card = described_class.find("r_hello_world")

      expect(card.type_name).to eq "String"
      expect(card.ruby_expression).to include("Hello World")
    end
  end

  describe "ruby_expression の妥当性" do
    it "全てのカードのruby_expressionが正しい型を返すこと" do
      described_class.all.each do |card|
        result = eval(card.ruby_expression) # rubocop:disable Security/Eval
        expect(result.class.name).to eq(card.type_name),
          "#{card.id}: expected #{card.type_name}, got #{result.class.name}"
      end
    end
  end
end
