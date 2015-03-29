module IsA
  class CategoriesController < ApplicationController

    def index
      @family_tree = IsA::Category.family_tree.to_a
      @characteristics = IsA::Category.characteristics_tree.to_a
      @components = IsA::Category.components_tree.to_a
    end

    def create
      @parser = Definition.new(sentence_params[:text])
      @isa_parser = @parser.parser
      render :new
    end

    def new
      @parser = Definition.new("Is a cat an animal? Does a cat have fur?")
      @isa_parser = @parser.parser
    end

    private

    def sentence_params
      params.require(:definition).permit(:text)
    end

  end
end