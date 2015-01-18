module IsA
  class Descriptor

    include Neo4j::ActiveNode

    property :name, index: :exact
    has_many :in, :categories, model_class: IsA::Category
    validates_uniqueness_of :name

    def self.for_category(category)
      query_as(:w).
      match(c:IsA::Category).
      optional_match("(category:`IsA::Category`)-[HAS_DESCRIPTOR]->(descriptor:`IsA::Descriptor`)").
      where("category.name = '#{category.name}'").
      return('DISTINCT descriptor').
      map(&:descriptor)
    end

  end
end
