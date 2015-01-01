class PartOfSpeechController < ApplicationController

  def edit
    @part_of_speech = ::PartOfSpeech.new(base_form: 'foo')
  end

end