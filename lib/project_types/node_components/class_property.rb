module NodeComponents
  class ClassProperty < AstNode
    def body
      json.dig('value', 'body', 'body')
    end    
  end
end