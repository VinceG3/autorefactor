function Component(ast) {
  this.ast = ast
  this.renderMethod = require('./render_method.js').fromComponent(this)
};

Component.prototype.clean = function() {
  if (!this.isValid) { throw('not a clean component!') }
  this.extractRenderVariableDeclaration()
  return this.ast
};

Component.prototype.extractRenderVariableDeclaration = function() {
  var varDec = this.renderMethod.extractVarDec();
  this.insertGetterMethod(varDec);
};

Component.prototype.insertGetterMethod = function(varDec) {
  return require('./insertion.js').performInsertion(this, varDec)
};

Component.prototype.isValid = function () {
  return this.ast.expression.original.left.object.property.name == 'Components'
};

Component.prototype.replaceVarDecWithGetter = function(varName) {
  debugger
};

Component.prototype.properties = function() {
  return this.ast.program.body[0].expression.right.arguments[0].properties
};

exports.fromAst = function(ast) {
  return new Component(ast)
};
