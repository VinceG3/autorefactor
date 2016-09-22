function Method(component) {
  this.component = component;
}

Method.prototype.setBody = function(methodBody) {
  this.body = methodBody
  this.createProperty()
  this.setPropertyBody()
  this.insertIntoComponent()
}

Method.prototype.createProperty = function() {
  var recast = require('recast')
  b = recast.types.builders
  n = recast.types.namedTypes
  n.Property.assert(add)
  debugger
}

Method.prototype.setPropertyBody = function() {
  debugger
}

Method.prototype.insertIntoComponent = function() {
  debugger
}

exports.fromComponent = function(component) {
  return new Method(component)
}