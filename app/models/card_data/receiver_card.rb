module CardData
  class ReceiverCard
    YAML_PATH = Rails.root.join("config/game_data/receiver_cards.yml")

    attr_reader :id, :label, :ruby_expression, :type_name

    def initialize(attrs)
      @id = attrs["id"]
      @label = attrs["label"]
      @ruby_expression = attrs["ruby_expression"]
      @type_name = attrs["type_name"]
    end

    class << self
      def all
        @all ||= YAML.safe_load_file(YAML_PATH, permitted_classes: []).map { |attrs| new(attrs) }
      end

      def find(id)
        index[id] || raise(ArgumentError, "Unknown receiver card: #{id}")
      end

      def valid_id?(id)
        index.key?(id)
      end

      def reload!
        @all = nil
        @index = nil
      end

      private

      def index
        @index ||= all.index_by(&:id)
      end
    end
  end
end
