module IsA
  class CategoriesController < ApplicationController

    before_filter :scope_trees, only: [:index, :create]

    def index
      @parser = Definition.new("Is a cat an animal?")
      @grammar_parser = @parser.parser.sentence_parser
    end

    def create
      @parser = Definition.new(sentence_params[:text])
      render :index
    end

    private

    def scope_trees
      @family_tree = IsA::Category.family_tree.to_a
      @characteristics = IsA::Category.characteristics_tree.to_a
    end

    def sentence_params
      params.require(:definition).permit(:text)
    end

  end
end