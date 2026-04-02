require "test_helper"

class CardData::MethodCardTest < ActiveSupport::TestCase
  setup do
    CardData::MethodCard.reload!
  end

  test ".all loads all method cards" do
    cards = CardData::MethodCard.all
    assert cards.size > 20
    assert cards.all? { |c| c.id.present? && c.name.present? }
  end

  test ".find returns card by id" do
    card = CardData::MethodCard.find("m_chars")
    assert_equal ".chars", card.name
    assert_equal "A", card.category
  end

  test ".find raises for unknown id" do
    assert_raises(ArgumentError) { CardData::MethodCard.find("m_nonexistent") }
  end

  test ".by_category filters correctly" do
    wild_cards = CardData::MethodCard.by_category("D")
    assert wild_cards.all? { |c| c.category == "D" }
    assert wild_cards.all?(&:wild?)
  end

  test ".valid_id? works" do
    assert CardData::MethodCard.valid_id?("m_chars")
    assert_not CardData::MethodCard.valid_id?("m_fake")
  end

  test ".proc_compatible_cards excludes generators and wilds" do
    cards = CardData::MethodCard.proc_compatible_cards
    assert cards.none?(&:wild?)
    assert cards.all?(&:proc_compatible?)
  end

  test ".wild_cards returns only wild cards" do
    cards = CardData::MethodCard.wild_cards
    assert cards.all?(&:wild?)
    assert_includes cards.map(&:id), "m_map"
    assert_includes cards.map(&:id), "m_group_by"
  end
end
