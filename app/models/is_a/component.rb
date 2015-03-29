# Components are distinct from characteristics; characteristics express some
# descriptor of a thing (e.g. color or size) as opposed to components, that
# indicate things are a *part* of something else (e.g. tires or steering wheels)
module IsA
  class Component

    include Neo4j::ActiveNode

    property :name, index: :exact
    has_many :both, :categories, model_class: IsA::Category
    validates_uniqueness_of :name

    before_create :singularize_word

    def self.part_of(category)
      query_as(:w).
      match(c:IsA::Category).
      optional_match("(category:`IsA::Category`)-[HAS_COMPONENT]->(component:`IsA::Component`)").
      where("category.name = '#{category.name}'").
      return('DISTINCT component').
      map(&:component)
    end

    def singularize_word
      self.name = self.name.singularize
    end

    def ==(other)
      self.name == other.name
    end

  end
end
