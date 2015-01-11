module IsA
  class Category

    include Neo4j::ActiveNode

    property :name, index: :exact

    validates_uniqueness_of :name

    has_many :out, :children, model_class: IsA::Category, type: :has_child
    has_many :in, :parents, model_class: IsA::Category, type: :has_parent
    has_many :both, :characteristics, model_class: IsA::Characteristic, type: :has_characteristic

    before_create :singularize_word

    def self.characteristics_tree
      query_as(:w).
      match(c:IsA::Category).
      optional_match("(category:`IsA::Category`)-[HAS_CHARACTERISTIC]->(characteristic:`IsA::Characteristic`)").
      return('DISTINCT category.name AS category, characteristic.name AS characteristic')
    end

    def self.family_tree
      query_as(:w).
      match(c:IsA::Category).
      optional_match("(parent:`IsA::Category`)-[HAS_CHILD]->(child:`IsA::Category`)").
      return('DISTINCT parent.name AS parent, child.name AS child')
    end

    def add_child(child)
      child.parents << self
      self.children << child
    end

    def remove_child(child)
      child.parents = child.parents.reject{|p| p == self}
      self.children = self.children.reject{|c| c == child}
    end

    def is_a_child_of?(thing=self, category)
      return false if thing.parents.empty?
      return true if thing.parents.where(name: category.name)
      thing.parents.detect{ |parent| is_a_child_of?(parent, category) }
    end

    def has_a?(category=self, thing)
      return false unless self.children.any?
      return true if self.children.include?(thing)
      self.children.detect{|c| c.has_a?(c, thing)}
    end

    def any_child_has?(category=self, characteristic)
      return false unless self.children.any?
      self.children.detect{|c| c.has?(characteristic) || c.any_child_has?(c, characteristic)}
    end

    def any_parent_has?(category=self, characteristic)
      return false unless self.parents.any?
      self.parents.detect{|p| p.has?(characteristic) || p.any_child_has?(p, characteristic)}
    end

    def is_a!(category)
      category.add_child(self)
    end

    def is_not!(category)
      category.remove_child(self)
    end

    def connected?
      self.parents.any? || self.children.any?
    end

    def has?(characteristic)
      return unless characteristic.persisted?
      IsA::Characteristic.for_category(self).to_a.include?(characteristic)
    end

    def has!(characteristic)
      self.characteristics << characteristic
    end

    def is_sibling?(category)
      shared_parent(category)
    end

    def shared_parent(category)
      @shared_parents ||= category.parents.to_a & self.parents.to_a
      @shared_parents.any? && @shared_parents.first
    end

    def plural_name
      self.name.pluralize
    end

    def singularize_word
      self.name = self.name.singularize
    end

  end
end
