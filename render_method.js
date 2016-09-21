function RenderMethod(component) {
  this.component = component
}

RenderMethod.prototype.clean = function() {
  debugger
}

exports.fromComponent = function(component) {
  renderMethod = new RenderMethod(component)
  return renderMethod
}