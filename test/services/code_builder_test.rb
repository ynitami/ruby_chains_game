require "test_helper"

class CodeBuilderTest < ActiveSupport::TestCase
  test "builds simple chain" do
    builder = CodeBuilder.new(
      receiver_id: "r_hello_world",
      method_entries: %w[m_split m_join]
    )
    assert_equal '" Hello World ".split.join', builder.full_chain_code
  end

  test "builds chain with wild card (identity block)" do
    builder = CodeBuilder.new(
      receiver_id: "r_string_array",
      method_entries: [{ "wild" => "m_map", "proc" => "m_to_s" }]
    )
    assert_equal '["Method", "Class", "Object", "Method"].map(&:to_s)', builder.full_chain_code
  end

  test "code_up_to_step returns partial chain" do
    builder = CodeBuilder.new(
      receiver_id: "r_hello_world",
      method_entries: %w[m_split m_size]
    )
    assert_equal '" Hello World ".split', builder.code_up_to_step(0)
    assert_equal '" Hello World ".split.size', builder.code_up_to_step(1)
  end

  test "step_labels returns correct labels" do
    builder = CodeBuilder.new(
      receiver_id: "r_hello_world",
      method_entries: ["m_split", { "wild" => "m_map", "proc" => "m_upcase" }, "m_join"]
    )
    assert_equal [".split", ".map(&:upcase)", ".join"], builder.step_labels
  end

  test "raises for unknown card id" do
    assert_raises(ArgumentError) do
      CodeBuilder.new(receiver_id: "r_hello_world", method_entries: ["m_fake"]).full_chain_code
    end
  end
end
