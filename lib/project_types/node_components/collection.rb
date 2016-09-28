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
      obj = children.find {|member| member.dig('key', 'name') == tag.to_s }
      self.class.member_class.new(obj)
    end
  end
end