class ParsersController < ApplicationController

  def index
  end

  def new
    @parser = Parser.new("This cat is cool.")
  end

  def create
    @parser = Parser.new(sentence_params[:text])
    render :new
  end

  private

  def sentence_params
    params.require(:parser).permit(:text)
  end

end