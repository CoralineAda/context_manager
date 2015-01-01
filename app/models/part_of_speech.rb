class PartOfSpeech

  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :base_form
  attr_accessor :form
  attr_accessor :is_physical

  FORMS = %w{ adjective adverb noun verb }

  def initialize(base_form:)
    self.base_form = base_form
  end

  def save
    object = klass.create(base_form: self.base_form)
    object.is_physical = self.is_physical if object.respond_to?(:is_physical)
  end

  def klass
    case self.form
      when 'adjective'; Gramercy::PartOfSpeech::Adjective
    end
  end

  def id
    1
  end

  def persisted?
    true
  end

end