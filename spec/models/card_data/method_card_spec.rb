require "rails_helper"

RSpec.describe CardData::MethodCard do
  before { described_class.reload! }

  describe ".all" do
    it "20種以上のメソッドカードが読み込まれること" do
      expect(described_class.all.size).to be > 20
    end
  end

  describe ".find" do
    it "IDでカードを取得できること" do
      card = described_class.find("m_chars")

      expect(card.name).to eq ".chars"
      expect(card.category).to eq "A"
    end

    context "存在しないIDの場合" do
      it "ArgumentErrorが発生すること" do
        expect { described_class.find("m_nonexistent") }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".wild_cards" do
    it ".map と .group_by が含まれること" do
      ids = described_class.wild_cards.map(&:id)

      expect(ids).to include("m_map", "m_group_by")
    end

    it "全てwild?がtrueであること" do
      expect(described_class.wild_cards).to all(be_wild)
    end
  end

  describe ".proc_compatible_cards" do
    it "切り札（wild）を含まないこと" do
      expect(described_class.proc_compatible_cards.select(&:wild?)).to be_empty
    end
  end
end
