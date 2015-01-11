module IsA
  class Characteristic

    include Neo4j::ActiveNode

    property :name, index: :exact
    has_many :in, :categories, model_class: IsA::Category
    validates_uniqueness_of :name

    before_create :singularize_word

    def self.for_category(category)
      query_as(:w).
      match(c:IsA::Category).
      optional_match("(category:`IsA::Category`)-[HAS_CHARACTERISTIC]->(characteristic:`IsA::Characteristic`)").
      where("category.name = '#{category.name}'").
      return('DISTINCT characteristic').
      map(&:characteristic)
    end

    def singularize_word
      self.name = self.name.singularize
    end

  end
end
