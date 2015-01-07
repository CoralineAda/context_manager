module Presenters
  class PartOfSpeech

    include Faceted::Presenter
    include ActiveModel::Conversion

    presents :generic, class_name: 'Gramercy::PartOfSpeech::Generic'

    field :base_form
    field :type

    attr_accessor :root_word, :property_attrs

    FORMS = %w{ adjective adverb noun verb }
    ADJECTIVE_ATTRIBUTES = Gramercy::PartOfSpeech::Generic::PROPERTY_LIST[:adjective]
    ADVERB_ATTRIBUTES = Gramercy::PartOfSpeech::Generic::PROPERTY_LIST[:adverb]
    NOUN_ATTRIBUTES = Gramercy::PartOfSpeech::Generic::PROPERTY_LIST[:noun]
    VERB_ATTRIBUTES = Gramercy::PartOfSpeech::Generic::PROPERTY_LIST[:verb]

    def root
      @root ||= Gramercy::Meta::Root.find_by(base_form: self.root_word)
    end

    def set_properties_from_attrs
      return unless property_attrs
      self.property_attrs.each{ |k,v| v && ! v.empty? && object.set_property(k,v) }
    end

    def set_root
      return unless root
      object.set_root(root)
    end

    def persisted?
      false
    end

  end
end