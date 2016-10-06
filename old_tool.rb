require 'json'
require 'pry'

Dir['./lib/project_types/node_components/*.rb'].each {|file| require file }
system('node gen_ast.js test_component.js.jsx')
string = IO.read('outputast.json')
json = JSON.parse(string)
component = NodeComponents::SourceFile.new(json)
IO.write('clean_ast.json', component.cleaned_ast.to_json)
system('node gen_js.js clean_ast.json')
