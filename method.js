function Method(component) {
  this.component = component;
}

Method.prototype.setBody = function(methodBody) {
  this.body = methodBody
  this.createProperty()
  this.moveRenderToEnd()
}

Method.prototype.createProperty = function() {
  var recast = require('recast')
  b = recast.types.builders
  var propertyList = component.properties()
  propertyList[propertyList.length] = b.Property
  debugger
}

Method.prototype.moveRenderToEnd = function() {
  debugger
}

exports.fromComponent = function(component) {
  return new Method(component)
}