module NodeComponents
  class SourceFile < AstNode
    component jsx_component: :body

    def jsx_component?
      is_mozilla_parser_output? and has_single_expression?
    end

    def is_mozilla_parser_output?
      json.keys == ["program", "loc", "type", "comments"]
    end

    def has_single_expression?
      json.dig('program', 'body').size == 1
    end

    def body
      json.dig('program', 'body')[0]
    end

    def cleaned_ast
      json
    end
  end
end