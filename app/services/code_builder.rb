# カードIDからRubyコード文字列を組み立てる。
# ユーザー入力は一切コード文字列に入らない（カードIDからの参照のみ）。
class CodeBuilder
  # method_entries の各要素は以下のいずれか:
  #   - String: 通常のメソッドカードID (例: "m_chars")
  #   - Hash: 切り札 + Proc引数 (例: { "wild" => "m_map", "proc" => "m_to_s" })
  def initialize(receiver_id:, method_entries:)
    @receiver = CardData::ReceiverCard.find(receiver_id)
    @method_entries = method_entries
  end

  # チェイン全体を1行のコードとして生成
  def full_chain_code
    "#{@receiver.ruby_expression}#{method_chain_code}"
  end

  # ステップNまでのコードを生成（中間結果取得用）
  def code_up_to_step(step_index)
    fragments = method_fragments
    "#{@receiver.ruby_expression}#{fragments[0..step_index].join}"
  end

  # 各ステップのメソッド表示名を返す
  def step_labels
    @method_entries.map { |entry| label_for(entry) }
  end

  def step_count
    @method_entries.size
  end

  private

  def method_chain_code
    method_fragments.join
  end

  def method_fragments
    @method_entries.map { |entry| fragment_for(entry) }
  end

  def fragment_for(entry)
    if entry.is_a?(Hash)
      wild_card = CardData::MethodCard.find(entry["wild"])
      proc_card = CardData::MethodCard.find(entry["proc"])
      proc_method_name = proc_card.code_fragment.delete_prefix(".")
      "#{wild_card.code_fragment}(&:#{proc_method_name})"
    else
      CardData::MethodCard.find(entry).code_fragment
    end
  end

  def label_for(entry)
    if entry.is_a?(Hash)
      wild_card = CardData::MethodCard.find(entry["wild"])
      proc_card = CardData::MethodCard.find(entry["proc"])
      proc_method_name = proc_card.code_fragment.delete_prefix(".")
      "#{wild_card.name}(&:#{proc_method_name})"
    else
      CardData::MethodCard.find(entry).name
    end
  end
end
