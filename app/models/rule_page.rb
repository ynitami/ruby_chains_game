class RulePage
  RULES_DIR = Rails.root.join("config/game_data/rules")

  PAGES = [
    { key: "basic",    title: "基本ルール",    file: "basic_rules.md" },
    { key: "advanced", title: "上級ルール",    file: "advanced_rules.md" },
    { key: "cards",    title: "カードリスト",  file: "card_list.md" },
    { key: "faq",      title: "FAQ",           file: "faq.md" }
  ].freeze

  attr_reader :key, :title, :html

  def initialize(key:, title:, html:)
    @key = key
    @title = title
    @html = html
  end

  class << self
    def all
      if Rails.env.production?
        @all ||= load_pages
      else
        load_pages
      end
    end

    def reload!
      @all = nil
    end

    private

    def load_pages
      PAGES.map do |page|
        markdown = RULES_DIR.join(page[:file]).read
        html = Commonmarker.to_html(markdown, options: {
          extension: { table: true, strikethrough: true },
          render: { unsafe: false }
        })
        new(key: page[:key], title: page[:title], html: html)
      end
    end
  end
end
