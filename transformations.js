Transformer = {
  transform: function(ast) {
    this.ast = ast
    component = this.getComponent(ast)
    component.clean()
    return this.ast
  },

  ast: {},
  component: {},
  
  getComponent: function() {
    return this.component = require('./component.js').fromAst(this.ast)
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