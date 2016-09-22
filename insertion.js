function Insertion(component, varDec) {
  this.component = component;
  this.varDec = varDec;
};

Insertion.prototype.perform = function() {
  this.newMethod = new require('./method.js').fromComponent(this.component)
  this.newMethod.setBody(this.getExpression())
  this.component.replaceVarDecWithGetter(this.getVarName())
  return true
};

Insertion.prototype.getExpression = function() {
  return this.varDec.declarations[0].init
};

Insertion.prototype.getVarName = function() {
  return this.varDec.declarations[0].id.name
};

exports.performInsertion = function(component, varDec) {
  return new Insertion(component, varDec).perform()
};
