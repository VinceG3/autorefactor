require 'json'
require 'pry'
Dir['./lib/project_types/node_components/*.rb'].each {|file| require file }

system('node gen_ast.js test_component.js.jsx')

string = IO.read('outputast.json')
json = JSON.parse(string)

component = NodeComponents::SourceFile.new(json)

component.call