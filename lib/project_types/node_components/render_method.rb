module NodeComponents
  class RenderMethod < AstNode
    component :expressions

    def return
      expressions.find(:return).body
    end

    def expressions_node
      json
    end
  end
end