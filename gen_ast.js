// Make sure we got a filename on the command line.
if (process.argv.length < 3) {
  console.log('Usage: node ' + process.argv[1] + ' FILENAME');
  process.exit(1);
}
// Read the file and print its contents.
var fs = require('fs')
  , filename = process.argv[2];


handleFile = function(err, data) {
  if (err) throw err;
  console.log('OK: ' + filename);
  main(data)
}

fs.readFile(filename, 'utf8', handleFile);

write_to_file = function(object) {
  var fs = require('fs');
  fs.writeFile("output.ast", JSON.stringify(object), function(err) {
      if(err) {
          return console.log(err);
      }
      console.log("The file was saved!");
  }); 
}

main = function(code) {
  var input = code;
  var output = require("babylon").parse(input, {
    // parse in strict mode and allow module declarations
    sourceType: "script",

    plugins: [
      // enable jsx and flow syntax
      "jsx",
      "flow"
    ]
  });
  write_to_file(output)
};
