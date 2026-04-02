module CardData
  class MethodCard
    YAML_PATH = Rails.root.join("config/game_data/method_cards.yml")

    attr_reader :id, :name, :category, :code_fragment, :description, :proc_compatible, :wild

    def initialize(attrs)
      @id = attrs["id"]
      @name = attrs["name"]
      @category = attrs["category"]
      @code_fragment = attrs["code_fragment"]
      @description = attrs["description"]
      @proc_compatible = attrs["proc_compatible"]
      @wild = attrs["wild"]
    end

    def wild?
      @wild
    end

    def proc_compatible?
      @proc_compatible
    end

    class << self
      def all
        @all ||= YAML.load_file(YAML_PATH).map { |attrs| new(attrs) }
      end

      def find(id)
        all.find { |c| c.id == id } || raise(ArgumentError, "Unknown method card: #{id}")
      end

      def by_category(category)
        all.select { |c| c.category == category }
      end

      def valid_id?(id)
        all.any? { |c| c.id == id }
      end

      def proc_compatible_cards
        all.select(&:proc_compatible?)
      end

      def wild_cards
        all.select(&:wild?)
      end

      def reload!
        @all = nil
      end
    end
  end
end
