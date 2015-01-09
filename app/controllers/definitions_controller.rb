class DefinitionsController < ApplicationController

  def new
    @parser = Definition.new("Is the cat cool?")
    @grammar_parser = @parser.parser.sentence_parser
  end

  def create
    @parser = Definition.new(sentence_params[:text])
    render :new
  end

  private

  def sentence_params
    params.require(:definition).permit(:text)
  end

end