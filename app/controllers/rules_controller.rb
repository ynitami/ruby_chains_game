class RulesController < ApplicationController
  def index
    @rule_pages = RulePage.all
  end
end
