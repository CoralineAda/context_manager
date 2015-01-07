module Gramercy
  module PartOfSpeech
    class GenericsController < ApplicationController

      def index
        @generic = Gramercy::PartOfSpeech::Generic.new
        @parts_of_speech = Gramercy::PartOfSpeech::Generic.all.order_by(:base_form, :asc).to_a
        @words_with_properties = Gramercy::PartOfSpeech::Generic.as('word').properties(:p).pluck('word, p.name, p.value').inject({}){|a, p| a[p[0].id] ||= []; a[p[0].id] << "#{p[1]}: #{p[2]}"; a}
      end

      def create
        if @generic = Gramercy::PartOfSpeech::Generic.create!(generic_params)
          if @generic.property_attributes
            @generic.property_attributes.each{ |k,v| v && ! v.empty? && @generic.set_property(k,v) }
          end
          if generic_params[:root_word]
            @root = Gramercy::Meta::Root.find_by(base_form: generic_params[:root_word])
            @generic.set_root(@root)
          end
          if @generic.root
            redirect_to gramercy_meta_root_path(@generic.root)
          else
            render :edit
          end
        else
          flash[:notice] = "The word could not be created."
          render :new
        end
      end

      def destroy
        @generic = Gramercy::PartOfSpeech::Generic.find(params[:id])
        @generic.destroy
        redirect_to gramercy_part_of_speech_generics_path
      end

      def edit
        @generic = Gramercy::PartOfSpeech::Generic.find(params[:id])
      end

      def new
        @generic = Gramercy::PartOfSpeech::Generic.new(root_word: params[:root_base_form])
      end

      def show
        @generic = Gramercy::PartOfSpeech::Generic.find(params[:id])
      end

      def update
        @generic = Gramercy::PartOfSpeech::Generic.find(params[:id])
        if @generic.update_attributes(generic_params)
          if @generic.property_attributes
            @generic.property_attributes.each{ |k,v| @generic.set_property(k,v)}
          end
          redirect_to gramercy_part_of_speech_generics_path
        else
           render :action => 'edit'
        end
      end

      private

      def generic_params
        params.require(:gramercy_part_of_speech_generic).permit!
      end

    end
  end
end