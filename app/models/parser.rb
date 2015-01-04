class Parser

  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :text
  attr_reader :id

  def initialize(text)
    self.text = text
    @id = 1
  end

  def parser
    @parser ||= Gramercy::Grammar::Parser.new(text.to_s)
  end

  def interrogative
    parser.interrogative
  end

  def sentence_type
    parser.sentence_type
  end

  def subject
    parser.subject
  end

  def verb
    parser.verb
  end

  def predicate
    parser.predicate
  end

  def positivity
    parser.positivity
  end

  def contexts
    parser.contexts
  end

  def persisted?
    false
  end

end