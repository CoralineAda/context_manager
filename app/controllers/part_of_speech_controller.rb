class PartOfSpeechController < ApplicationController

  def index
    @parts_of_speech = Gramercy::PartOfSpeech::Generic.all.order_by(:base_form, :asc).to_a
    @words_with_properties = Gramercy::PartOfSpeech::Generic.as('word').properties(:p).pluck('word, p.name, p.value').inject({}){|a, p| a[p[0].id] ||= []; a[p[0].id] << "#{p[1]}: #{p[2]}"; a}
  end

  def create
    @part_of_speech = Presenters::PartOfSpeech.new(pos_params)
    if @part_of_speech.save
      @part_of_speech.set_properties_from_attrs
      @part_of_speech.set_root
      redirect_to @part_of_speech.root
    else
      render :new
    end
  end

  def new
    @part_of_speech = Presenters::PartOfSpeech.new(base_form: params[:root_base_form], root_word: params[:root_base_form])
  end

  def edit
  end

  def destroy
    pos = Gramercy::PartOfSpeech::Generic.find(params[:id])
    root = pos.root
    pos.destroy
    redirect_to root
  end

  def update
    pos = Presenters::PartOfSpeech.new(pos_params)
    if pos.save
      redirect_to pos.root
    else
      flash[:notice] = "The word could not be added."
    end
  end

  private

  def pos_params
    params.require(:part_of_speech).permit!
  end

end