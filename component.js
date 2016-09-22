function Component(ast) {
  this.ast = ast
  this.renderMethod = equire('./render_method.js').fromComponent(this)
}

Component.prototype.clean = function() {
  if (!this.isValid) { throw('not a clean component!') }
  this.extractRenderVariableDeclaration()
  return this.ast
}

Component.prototype.extractRenderVariableDeclaration = function() {
  var VarDec = this.renderMethod.extractVarDec();
  this.insertGetterMethod(varDec);
}

Component.prototype.isValid = function () {
  return this.ast.expression.original.left.object.property.name == 'Components'
}

exports.fromAst = function(ast) {
  return new Component(ast)
}