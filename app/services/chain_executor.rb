# カードIDの配列を受け取り、ステップごとにRubyを実行して結果を返す。
class ChainExecutor
  def self.call(receiver_id:, method_entries:)
    new(receiver_id: receiver_id, method_entries: method_entries).call
  end

  def initialize(receiver_id:, method_entries:)
    @builder = CodeBuilder.new(receiver_id: receiver_id, method_entries: method_entries)
  end

  def call
    steps = []

    @builder.step_count.times do |i|
      code = @builder.code_up_to_step(i)
      result = SandboxRunner.execute(code)

      if result.error
        return {
          success: false,
          error_at_step: i + 1,
          error_message: result.error,
          steps: steps
        }
      end

      steps << {
        method: @builder.step_labels[i],
        value: result.value,
        class_name: result.class_name
      }
    end

    {
      success: true,
      final_result: steps.last ? { value: steps.last[:value], class_name: steps.last[:class_name] } : nil,
      steps: steps
    }
  end
end
