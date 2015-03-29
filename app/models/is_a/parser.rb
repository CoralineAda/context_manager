module IsA
  class Parser

    attr_reader :sentences, :text

    def initialize(text="")
      @sentences = text.downcase.gsub(/\.|\?|\!|\;/, "\\&\n").lines.map(&:strip)
      @text = @sentences.first
      process_sentences if @sentences.length > 1
      parser_stack << self
    end

    def response
      response_text ||= set_category if is_category_definition?
      response_text ||= set_characteristic if is_characteristic_definition?
      response_text ||= characteristic_answer if is_characteristic_question?
      response_text ||= set_component if is_component_definition?
      response_text ||= component_answer if is_component_question?
      response_text ||= unset_category if is_category_undefinition?
      response_text ||= category_answer if is_category_question?
      response_text ||= definition if is_definition_question?
      response_text ||= "I don't know what you mean."
      response_text
    end

    def parser_stack
      @parser_stack ||= []
    end

    def process_sentences
      self.sentences[1..-1].each do |sentence|
        parser_stack << IsA::Parser.new(sentence)
        parser_stack.last.response
      end
    end

    def sentence_parser
      @sentence_parser ||= Gramercy::Grammar::Parser.new(self.text)
    end

    private

    def category_answer
      return "I don't know what #{subject.name} means." unless subject.connected?
      return "No, but they are both #{category.shared_parent(category).plural_name}." if subject.is_sibling?(category)
      return "Yes." if subject.is_a_child_of?(category)
      return "#{subject.plural_name} can sometimes be #{category.plural_name}." if category.has_a?(subject)
      return "I don't think so, but I don't know that much about #{category.plural_name}." unless category.children.any?
      return "Some #{subject.plural_name} are #{category.plural_name}." if subject.has_a?(category)
      "I don't think so."
    end

    def characteristic_answer
      return "Yes." if subject.has?(characteristic) || subject.any_parent_has?(characteristic)
      return "Some are." if subject.any_child_has?(characteristic)
      "Not as far as I know."
    end

    def component_answer
      return "Yep!" if subject.composed_of?(component) || subject.any_parent_composed_of?(component)
      if child = subject.any_child_composed_of?(component)
        return "Some #{subject.name.pluralize} do. Like #{child.name.pluralize}, for example."
      end
      "Hmm, not as far as I know."
    end

    def definition
      return "#{subject.pluralize} are #{subject.parents.first.name.pluralize}."
    end

    def unset_category
      subject.is_not! category
      "OK, I understand."
    end

    def set_category
      return unless category
      subject.is_a! category
      "Got it."
    end

    def set_characteristic
      subject.describe! characteristic
      "I'll remember that."
    end

    def set_component
      subject.composed_of! component
      "Cool!"
    end

    # HERE working on these methods... may need something more sophisticated?

    # Is a dog yellow?
    def is_characteristic_question?
      text =~ /^is (a|an)/
    end

    # An egg is ovoid.
    def is_characteristic_definition?
      text =~ /.+\b(is|are) [^(a|an)]/
    end

    # A dog is not a cat.
    def is_category_undefinition?
      text =~/\bis not\b/ || text =~ /\bisn't\b/
    end

    # Is an egg an animal?
    def is_category_question?
      !!(text =~ /^(is|was) (the|a) .+ (the|a)/)
    end

    # Does a dog have legs?
    def is_component_question?
      text =~ /^(do|does).+(have|has)/
    end

    # A wagon has wheels.
    def is_component_definition?
      text =~ /.+\bhas/
    end

    def is_definition_question?
      sentence_parser.interrogative
    end

    def is_category_definition?
      text =~/.+\b(is|are) (a|an)/
    end

    def is_question?
      is_category_question? || is_characteristic_question?
    end

    def adjectives
      @adjectives ||= sentence_parser.adjectives
    end

    def nouns
      @nouns ||= sentence_parser.nouns
    end

    def singularized_nouns
      nouns.map(&:singularize)
    end

    def create_root_from(category_name)
      return unless category_name
      return unless sentence_parser.contexts.any?
      return if Gramercy::Meta::Root.find_by(base_form: category_name)
      root = Gramercy::Meta::Root.create!(base_form: category_name)
      sentence_parser.contexts.each{ |context| context.add_expression(root) }
    end

    def subject
      return if singularized_nouns.detect{|n| n.nil? }
      @subject ||= begin
        category = Category.find_or_create_by(name: singularized_nouns.first)
        create_root_from(category.name)
        category
      end
    end

    def category
      return unless sentence_parser.object
      if is_question?
        Category.where(name: sentence_parser.object).last || Category.new(name: sentence_parser.object)
      else
        Category.find_or_create_by(name: sentence_parser.object)
      end
    end

    def component
      if is_question?
        Component.where(name: sentence_parser.object.singularize).last || Component.new(name: sentence_parser.object)
      else
        Component.find_or_create_by(name: sentence_parser.object)
      end
    end

    def characteristic
      if is_question?
        Characteristic.where(name: sentence_parser.object.singularize).last || Characteristic.new(name: sentence_parser.object)
      else
        Characteristic.find_or_create_by(name: sentence_parser.adjectives.last || sentence_parser.object)
      end
    end

  end
end