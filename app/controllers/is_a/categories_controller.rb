module IsA
  class CategoriesController < ApplicationController

    def index
      @family_tree = IsA::Category.family_tree.to_a
      @characteristics = IsA::Category.characteristics_tree.to_a
    end

    def create
      @parser = Definition.new(sentence_params[:text])
      @grammar_parser = @parser.parser.sentence_parser
      render :new
    end

    def new
      @parser = Definition.new("Is a cat an animal?")
      @grammar_parser = @parser.parser.sentence_parser
    end

    private

    def sentence_params
      params.require(:definition).permit(:text)
    end

  end
end