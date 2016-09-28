module NodeComponents 
  class JsxComponent < AstNode
    component :identifier, class: 'MemberExpression'
    component :render_method
    component :members

    def identifier_node
      json.dig('expression', 'left')
    end

    def full_name
      identifier.call
    end
22
    def members_node
      json.dig('expression', 'right', 'arguments')[0].dig('properties')
    end

    def render_method_node
      members.find(:render).body
    end

    def call
      render_method.return
    end
  end
end