require 'pry'
Dir['./lib/try_parse/*.rb'].each {|f| require f }

ast = SourceFile.new('working.js.jsx')
ast.transform
js = ast.render
puts js
