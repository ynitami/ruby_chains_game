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
        @all ||= YAML.load_file(YAML_PATH).map { |attrs| new(attrs) }
      end

      def find(id)
        all.find { |c| c.id == id } || raise(ArgumentError, "Unknown receiver card: #{id}")
      end

      def valid_id?(id)
        all.any? { |c| c.id == id }
      end

      def reload!
        @all = nil
      end
    end
  end
end
