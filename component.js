Component = {
  from_ast: function(ast) {
    
  },

  clean: function(ast) {
    this.ast = ast.program.body[0]
    return ast
  },

  isValid: function() {
    return this.ast.expression.original.left.object.property.name == 'Components'
  }
}