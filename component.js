function Component(ast) {
  this.ast = ast
}

Component.prototype.clean = function() {
  if (!this.isValid) { throw('not a clean component!') }
  this.getRenderMethod().clean()
  return this.ast
}

Component.prototype.isValid = function () {
  return this.ast.expression.original.left.object.property.name == 'Components'
}

Component.prototype.getRenderMethod = function() {
  return require('./render_method.js').fromComponent(this)
}

exports.fromAst = function(ast) {
  component = new Component(ast)
  return component
}