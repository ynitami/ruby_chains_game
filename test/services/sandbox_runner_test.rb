require "test_helper"

class SandboxRunnerTest < ActiveSupport::TestCase
  test "executes simple expression" do
    result = SandboxRunner.execute('"hello".upcase')
    assert_nil result.error
    assert_equal '"HELLO"', result.value
    assert_equal "String", result.class_name
  end

  test "returns error for invalid code" do
    result = SandboxRunner.execute('"hello".digits')
    assert_not_nil result.error
    assert_match(/NoMethodError/, result.error)
  end

  test "blocks system calls" do
    result = SandboxRunner.execute('system("echo hacked")')
    assert_not_nil result.error
    assert_match(/SecurityError|Blocked/, result.error)
  end

  test "blocks require" do
    result = SandboxRunner.execute('require "net/http"')
    assert_not_nil result.error
    assert_match(/SecurityError|Blocked/, result.error)
  end

  test "handles array result" do
    result = SandboxRunner.execute('"a,b,c".split(",")')
    assert_nil result.error
    assert_equal '["a", "b", "c"]', result.value
    assert_equal "Array", result.class_name
  end

  test "handles hash result" do
    result = SandboxRunner.execute('["a","b","a"].tally')
    assert_nil result.error
    assert_equal '{"a"=>2, "b"=>1}', result.value
    assert_equal "Hash", result.class_name
  end

  test "handles integer result" do
    result = SandboxRunner.execute("[1,2,3].size")
    assert_nil result.error
    assert_equal "3", result.value
    assert_equal "Integer", result.class_name
  end
end
