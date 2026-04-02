require "test_helper"

class ChainExecutorTest < ActiveSupport::TestCase
  test "successful chain execution" do
    result = ChainExecutor.call(
      receiver_id: "r_hello_world",
      method_entries: %w[m_split m_join]
    )
    assert result[:success]
    assert_equal "String", result[:final_result][:class_name]
    assert_equal 2, result[:steps].size
    assert_equal ".split", result[:steps][0][:method]
    assert_equal ".join", result[:steps][1][:method]
  end

  test "error stops at failing step" do
    result = ChainExecutor.call(
      receiver_id: "r_hello_world",
      method_entries: %w[m_split m_digits]
    )
    assert_not result[:success]
    assert_equal 2, result[:error_at_step]
    assert_match(/NoMethodError/, result[:error_message])
    assert_equal 1, result[:steps].size
  end

  test "wild card with proc argument" do
    result = ChainExecutor.call(
      receiver_id: "r_string_array",
      method_entries: [{ "wild" => "m_map", "proc" => "m_size" }]
    )
    assert result[:success]
    assert_equal "Array", result[:final_result][:class_name]
    assert_equal ".map(&:size)", result[:steps][0][:method]
  end

  test "empty method list returns nil final_result" do
    result = ChainExecutor.call(
      receiver_id: "r_hello_world",
      method_entries: []
    )
    assert result[:success]
    assert_nil result[:final_result]
    assert_empty result[:steps]
  end

  test "digits on integer receiver" do
    result = ChainExecutor.call(
      receiver_id: "r_csv_numbers",
      method_entries: %w[m_size m_digits]
    )
    assert result[:success]
    assert_equal "Array", result[:final_result][:class_name]
  end

  test "chain with generator card" do
    result = ChainExecutor.call(
      receiver_id: "r_nested_array",
      method_entries: %w[m_flatten m_concat_array]
    )
    assert result[:success]
    assert_equal "Array", result[:final_result][:class_name]
  end

  test "hash receiver with keys" do
    result = ChainExecutor.call(
      receiver_id: "r_date_hash",
      method_entries: %w[m_keys]
    )
    assert result[:success]
    assert_equal "Array", result[:final_result][:class_name]
  end
end
