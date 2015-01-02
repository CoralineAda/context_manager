class PartOfSpeech

  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :base_form
  attr_accessor :root_word
  attr_accessor :type
  attr_accessor :properties

  FORMS = %w{ adjective adverb noun verb }
  ADJECTIVE_ATTRIBUTES = Gramercy::PartOfSpeech::Generic::PROPERTY_LIST[:adjective]
  ADVERB_ATTRIBUTES = Gramercy::PartOfSpeech::Generic::PROPERTY_LIST[:adverb]
  NOUN_ATTRIBUTES = Gramercy::PartOfSpeech::Generic::PROPERTY_LIST[:noun]
  VERB_ATTRIBUTES = Gramercy::PartOfSpeech::Generic::PROPERTY_LIST[:verb]

  def initialize(params={})
    self.base_form = params[:base_form]
    self.root_word = params[:root_word]
    self.properties = params[:properties]
    self.type = params[:type]
  end

  def save
    object = Gramercy::PartOfSpeech::Generic.create!(base_form: self.base_form, type: self.type)
    object.set_root(root)
    self.properties.each{ |k,v| v && ! v.empty? && object.set_property(k,v) }
  end

  def id
    1
  end

  def root
    @root ||= Gramercy::Meta::Root.find_by(base_form: self.root_word)
  end

  def persisted?
    true
  end

end