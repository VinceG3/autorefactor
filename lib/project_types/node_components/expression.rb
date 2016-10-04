module NodeComponents
  class Expression < AstNode
    def body
      json.dig('argument')
    end
  end
end