module NodeComponents
  class MemberExpression < AstNode
    def first
      json.dig('object', 'object', 'name')
    end

    def second
      json.dig('object', 'property', 'name')
    end

    def third
      json.dig('property', 'name')
    end

    def call
      first + '.' + second + '.' + third
    end
  end
end