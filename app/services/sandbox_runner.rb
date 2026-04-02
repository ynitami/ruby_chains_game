# サンドボックス内でRubyコードを実行する。
# 別プロセスで実行し、タイムアウトと出力制限を適用する。
class SandboxRunner
  TIMEOUT_SECONDS = 3
  MAX_OUTPUT_LENGTH = 10_000

  Result = Data.define(:value, :class_name, :error)

  def self.execute(code)
    new(code).execute
  end

  def initialize(code)
    @code = code
  end

  def execute
    script = build_script
    stdout, stderr, status = run_in_subprocess(script)

    if status.success?
      parse_success(stdout)
    else
      parse_error(stderr, stdout)
    end
  end

  private

  def build_script
    <<~RUBY
      # サンドボックス: 危険な操作を無効化
      [:system, :exec, :spawn, :fork, :`, :open].each do |m|
        Kernel.define_method(m) { |*| raise SecurityError, "Blocked: \#{m}" }
      end

      # require/loadを無効化
      def require(*); raise SecurityError, "Blocked: require"; end
      def require_relative(*); raise SecurityError, "Blocked: require_relative"; end
      def load(*); raise SecurityError, "Blocked: load"; end

      # File/IO/Dir等のクラスメソッドを無効化
      [File, IO, Dir].each do |klass|
        klass.define_singleton_method(:new) { |*| raise SecurityError, "Blocked: \#{klass}.new" }
        [:read, :write, :open, :delete, :rename, :exist?, :glob, :foreach, :entries].each do |m|
          if klass.respond_to?(m)
            klass.define_singleton_method(m) { |*| raise SecurityError, "Blocked: \#{klass}.\#{m}" }
          end
        end
      end

      begin
        result = eval(#{@code.inspect})
        value_str = result.inspect
        value_str = value_str[0, #{MAX_OUTPUT_LENGTH}] if value_str.length > #{MAX_OUTPUT_LENGTH}
        puts "OK"
        puts result.class.name
        puts value_str
      rescue => e
        $stderr.puts "\#{e.class}: \#{e.message}"
        exit 1
      end
    RUBY
  end

  def run_in_subprocess(script)
    require "open3"
    require "timeout"

    Timeout.timeout(TIMEOUT_SECONDS) do
      Open3.capture3("ruby", "-e", script)
    end
  rescue Timeout::Error
    ["", "Timeout::Error: 実行時間が#{TIMEOUT_SECONDS}秒を超えました", OpenStruct.new(success?: false)]
  end

  def parse_success(stdout)
    lines = stdout.strip.split("\n", 3)
    Result.new(value: lines[2] || "", class_name: lines[1] || "NilClass", error: nil)
  end

  def parse_error(stderr, _stdout)
    error_msg = stderr.strip
    error_msg = error_msg[0, MAX_OUTPUT_LENGTH] if error_msg.length > MAX_OUTPUT_LENGTH
    Result.new(value: nil, class_name: nil, error: error_msg)
  end
end
