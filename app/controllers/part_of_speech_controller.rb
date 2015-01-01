class PartOfSpeechController < ApplicationController

  def edit
    @part_of_speech = ::PartOfSpeech.new(base_form: 'word', root_word: params[:root_base_form])
  end

  def update
    generic = PartOfSpeech.new(pos_params)
    if generic.save
      redirect_to generic.root
    else
      flash[:notice] = "The root could not be added."
    end
  end

  private

  def pos_params
    params.require(:part_of_speech).permit!#(:base_form, :type, :root_word, :properties => [])
  end

end