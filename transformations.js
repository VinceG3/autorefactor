Transformer = {
  transform: function(ast) {
    this.ast = ast
    this.getComponent(ast).clean()
    return this.ast
  },

  ast: {},
  component: {},
  
  getComponent: function() {
    require('./component.js').from_ast(this.ast)
  },

  isComponent: function() {
    
  },

  renderMethod: function() {
    debugger
  },

  cleanRender: function() {
    debugger
  },

  cleanRenderMethod: function() {
    if (!this.isComponent()) { throw('not a component') }
    if (!this.cleanRender()) { throw('render method already clean!') }
    this.extractFirstRenderLine()
  }
}

exports.run = function(ast) {
  transformed = Transformer.transform(ast)
  return transformed
}