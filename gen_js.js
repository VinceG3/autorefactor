Generator = {
  getCode: function() {
    // Make sure we got a filename on the command line.
    if (process.argv.length < 3) {
      process.exit(1);
    }
    // Read the file and print its contents.
    var fs = require('fs')
    var filename = process.argv[2];

    fs.readFile(filename, 'utf8', this.handleFile(filename));
  },

  handleFile: function(filename) {
    that = this;
    return function(err, data) {
      if (err) throw err;
      ast = JSON.parse(data)
      code = that.recast.print(ast).code
      console.log(code)
      this.writeToFile(code)
    }
  },

  writeToFile: function(object) {
    var fs = require('fs');
    fs.writeFile("output.js", JSON.stringify(object), function(err) {}); 
  },

  parseWithBabylon: function(code) {
    var input = code;
    var output = require("babylon").parse(input, {
      sourceType: "script",

      plugins: [
        "jsx",
        "flow"
      ]
    });
    this.writeToFile(output)
  },

  recast: require('recast'),

  parseWithRecast: function(code) {
    return this.recast.parse(code);
  },

  getAst: function() {
    this.getCode();
    return this.code
  },

  toAst: function(code) {
    return this.parseWithRecast(code)
  },

  runTransformations: function(code) {
    var ast = this.toAst(code)
    var transformed = require('./transformations.js').run(ast)
    this.writeToFile(this.recast.print(transformed).code)
  },

  getTransformedCode: function() {
    return this.recast.print(this.getAst()).code;
  }
}

Generator.getTransformedCode()
