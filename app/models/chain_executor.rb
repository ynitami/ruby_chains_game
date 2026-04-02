class ChainExecutor
  def self.call(receiver_id:, method_entries:)
    new(receiver_id: receiver_id, method_entries: method_entries).call
  end

  def self.validate(receiver_id:, method_entries:)
    unless CardData::ReceiverCard.valid_id?(receiver_id)
      return "不正なレシーバーカードです"
    end

    valid = method_entries.all? do |entry|
      if entry.is_a?(Hash)
        CardData::MethodCard.valid_id?(entry["wild"]) && CardData::MethodCard.valid_id?(entry["proc"])
      else
        CardData::MethodCard.valid_id?(entry)
      end
    end
    "不正なメソッドカードが含まれています" unless valid
  end

  def self.parse_params(raw_entries)
    return [] if raw_entries.blank?

    raw_entries.map do |entry|
      if entry.is_a?(ActionController::Parameters) || entry.is_a?(Hash)
        entry.respond_to?(:permit) ? entry.permit(:wild, :proc).to_h.stringify_keys : entry.stringify_keys
      else
        entry.to_s
      end
    end
  end

  def initialize(receiver_id:, method_entries:)
    @builder = CodeBuilder.new(receiver_id: receiver_id, method_entries: method_entries)
  end

  def call
    steps = []
    labels = @builder.step_labels

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
        method: labels[i],
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
