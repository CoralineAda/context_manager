module IsA
  class Parser

    attr_reader :text

    def initialize(text="")
      @text = text.downcase
    end

    def response
      response_text = set_characteristic if is_characteristic_definition?
      response_text ||= characteristic_answer if is_characteristic_question?
      response_text ||= unset_category if is_category_undefinition?
      response_text ||= set_category if is_category_definition?
      response_text ||= category_answer if is_category_question?
      response_text
    end

    def sentence_parser
      Gramercy::Grammar::Parser.new(self.text)
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
      return "Yes." if subject.has?(characteristic)
      return "#{subject.name.pluralize.capitalize} sometimes do." if subject.any_child_has?(characteristic)
      return "It might." if subject.any_parent_has?(characteristic)
      "Not as far as I know."
    end

    def unset_category
      subject.is_not! category
      "OK, I understand."
    end

    def set_category
      subject.is_a! category
      "Got it."
    end

    def set_characteristic
      subject.has! characteristic
      "I'll remember that."
    end

    def is_characteristic_question?
      text =~ /^does.+\?$/
    end

    def is_characteristic_definition?
      text =~ /\bhas\b/
    end

    def is_category_undefinition?
      text =~/\bis not\b/
    end

    def is_category_question?
      text =~ /^is.+\?$/
    end

    def is_category_definition?
      ! is_category_question? && ! is_characteristic_definition? && ! is_characteristic_question?
    end

    def is_question?
      is_category_question? || is_characteristic_question?
    end

    def nouns
      @nouns ||= sentence_parser.nouns
    end

    def singularized_nouns
      nouns.map(&:singularize)
    end

    def create_root_from(category_name)
      return if Gramercy::Meta::Root.find_by(base_form: category_name)
      root = Gramercy::Meta::Root.create!(base_form: category_name)
      sentence_parser.contexts.each{ |context| context.add_expression(root) }
    end

    def subject
      category = Category.find_or_create_by(name: singularized_nouns.first)
      create_root_from(category.name)
      category
    end

    def category
      return unless singularized_nouns.any?
      if is_question?
        Category.where(name: singularized_nouns.last).last || Category.new(name: nouns.last)
      else
        Category.find_or_create_by(name: singularized_nouns.last)
      end
    end

    def characteristic
      if is_question?
        Characteristic.where(name: singularized_nouns.last).last || Characteristic.new(name: nouns.last)
      else
        Characteristic.find_or_create_by(name: singularized_nouns.last)
      end
    end

  end
end