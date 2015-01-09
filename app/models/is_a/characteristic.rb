module IsA
  class Characteristic

    include Neo4j::ActiveNode

    property :name, index: :exact
    has_many :in, :categories, model_class: IsA::Category
    validates_uniqueness_of :name

    before_create :singularize_word

    def singularize_word
      self.name = self.name.singularize
    end

  end
end
