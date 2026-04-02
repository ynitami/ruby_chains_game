class CodeBuilder
  def initialize(receiver_id:, method_entries:)
    @receiver = CardData::ReceiverCard.find(receiver_id)
    @method_entries = method_entries
  end

  def full_chain_code
    "#{@receiver.ruby_expression}#{method_fragments.join}"
  end

  def code_up_to_step(step_index)
    "#{@receiver.ruby_expression}#{method_fragments[0..step_index].join}"
  end

  def step_labels
    @step_labels ||= resolved_entries.map { |e| e[:label] }
  end

  def step_count
    @method_entries.size
  end

  private

  def method_fragments
    @method_fragments ||= resolved_entries.map { |e| e[:fragment] }
  end

  def resolved_entries
    @resolved_entries ||= @method_entries.map { |entry| resolve(entry) }
  end

  def resolve(entry)
    if entry.is_a?(Hash)
      wild_card = CardData::MethodCard.find(entry["wild"])
      proc_card = CardData::MethodCard.find(entry["proc"])
      proc_method_name = proc_card.code_fragment.delete_prefix(".")
      {
        fragment: "#{wild_card.code_fragment}(&:#{proc_method_name})",
        label: "#{wild_card.name}(&:#{proc_method_name})"
      }
    else
      card = CardData::MethodCard.find(entry)
      { fragment: card.code_fragment, label: card.name }
    end
  end
end
