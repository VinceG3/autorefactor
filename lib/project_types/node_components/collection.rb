module NodeComponents
  class Collection < AstNode
    def children
      json.each
    end

    def self.member_class
      class_name = self.name.demodulize.singularize
      NodeComponents.const_get(class_name)
    end

    def find(tag)
      json = find_member(tag)
      self.class.member_class.new(json)
    end
  end
end