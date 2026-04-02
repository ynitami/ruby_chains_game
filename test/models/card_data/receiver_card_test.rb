require "test_helper"

class CardData::ReceiverCardTest < ActiveSupport::TestCase
  setup do
    CardData::ReceiverCard.reload!
  end

  test ".all loads all receiver cards" do
    cards = CardData::ReceiverCard.all
    assert_equal 10, cards.size
  end

  test ".find returns card by id" do
    card = CardData::ReceiverCard.find("r_hello_world")
    assert_equal "String", card.type_name
    assert_includes card.ruby_expression, "Hello World"
  end

  test ".find raises for unknown id" do
    assert_raises(ArgumentError) { CardData::ReceiverCard.find("r_nonexistent") }
  end

  test ".valid_id? works" do
    assert CardData::ReceiverCard.valid_id?("r_hello_world")
    assert_not CardData::ReceiverCard.valid_id?("r_fake")
  end

  test "all cards have valid ruby_expression" do
    CardData::ReceiverCard.all.each do |card|
      result = eval(card.ruby_expression)
      assert_equal card.type_name, result.class.name,
        "#{card.id}: expected #{card.type_name}, got #{result.class.name}"
    end
  end
end
