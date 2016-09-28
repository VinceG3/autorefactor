module NodeComponents
  class RenderMethod < AstNode
    def expressions
      Expressions.new(expressions_node)
    end

    def return
      expressions.find(:return).body
    end
  end
end