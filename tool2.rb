require 'pry'
Dir['./lib/try_parse/*.rb'].each {|f| require f }

ast = SourceFile.new('working.js.jsx').to_ast
problems = ast.lint
puts problems
