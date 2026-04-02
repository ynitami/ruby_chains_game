require "rails_helper"

RSpec.describe SandboxRunner do
  describe ".execute" do
    context "正常なRubyコードの場合" do
      it "文字列の結果を返せること" do
        result = described_class.execute('"hello".upcase')

        expect(result.error).to be_nil
        expect(result.value).to eq '"HELLO"'
        expect(result.class_name).to eq "String"
      end

      it "配列の結果を返せること" do
        result = described_class.execute('"a,b,c".split(",")')

        expect(result.error).to be_nil
        expect(result.value).to eq '["a", "b", "c"]'
        expect(result.class_name).to eq "Array"
      end

      it "Hashの結果を返せること" do
        result = described_class.execute('["a","b","a"].tally')

        expect(result.error).to be_nil
        expect(result.value).to eq '{"a"=>2, "b"=>1}'
        expect(result.class_name).to eq "Hash"
      end

      it "Integerの結果を返せること" do
        result = described_class.execute("[1,2,3].size")

        expect(result.error).to be_nil
        expect(result.value).to eq "3"
        expect(result.class_name).to eq "Integer"
      end
    end

    context "実行時エラーが発生するコードの場合" do
      it "NoMethodErrorのメッセージを返すこと" do
        result = described_class.execute('"hello".digits')

        expect(result.error).to match(/NoMethodError/)
      end
    end

    describe "セキュリティ制限" do
      it "systemコールをブロックすること" do
        result = described_class.execute('system("echo hacked")')

        expect(result.error).to match(/Blocked.*SecurityError/)
      end

      it "backtick実行をブロックすること" do
        result = described_class.execute('`whoami`')

        expect(result.error).to match(/Blocked.*SecurityError/)
      end

      it "requireをブロックすること" do
        result = described_class.execute('require "net/http"')

        expect(result.error).to match(/Blocked.*SecurityError/)
      end

      it "File.readをブロックすること" do
        result = described_class.execute('File.read("/etc/passwd")')

        expect(result.error).to match(/Blocked.*SecurityError/)
      end

      it "execをブロックすること" do
        result = described_class.execute('exec("ls")')

        expect(result.error).to match(/Blocked.*SecurityError/)
      end

      it "loadをブロックすること" do
        result = described_class.execute('load "/etc/passwd"')

        expect(result.error).to match(/Blocked.*SecurityError/)
      end

      it "ENV参照をブロックすること" do
        result = described_class.execute('ENV["HOME"]')

        expect(result.error).to match(/Blocked.*SecurityError/)
      end

      it "ObjectSpaceをブロックすること" do
        result = described_class.execute('ObjectSpace.each_object(String).first')

        expect(result.error).to match(/Blocked.*SecurityError/)
      end

      it "IO.popenをブロックすること" do
        result = described_class.execute('IO.popen("ls").read')

        expect(result.error).to match(/Blocked.*SecurityError/)
      end
    end

    context "出力が非常に大きい場合" do
      it "結果が切り詰められること" do
        result = described_class.execute('"x" * 100_000')

        expect(result.error).to be_nil
        expect(result.value.length).to be <= SandboxRunner::MAX_OUTPUT_LENGTH + 100
      end
    end
  end
end
