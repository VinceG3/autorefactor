function RenderMethod(component) {
  this.component = component
  this.method = (
    component
      .ast
      .program
      .body[0]
      .expression
      .right
      .arguments[0]
      .properties
      .filter(function(property){return property.key.name === 'render'}))[0];
  this.body = this.method.value.body.body;
}

RenderMethod.prototype.isClean = function() {
  if (this.body[0].type === 'ReturnStatement') { return true };
  return false
}

RenderMethod.prototype.clean = function() {
  if (this.isClean()) { return true };

}

exports.fromComponent = function(component) {
  return new RenderMethod(component)
}