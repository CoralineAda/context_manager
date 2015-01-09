class Definition

  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :text
  attr_reader :id

  def initialize(text)
    self.text = text
    @id = 1
  end

  def parser
    @parser ||= IsA::Parser.new(text.to_s)
  end

  def persisted?
    false
  end

  def response
    parser.response
  end

end