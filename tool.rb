require 'pry'
require 'active_support/core_ext/object/blank.rb'
require './lib/try_parse/parse_machine'
require './lib/try_parse/classifier'
require './lib/try_parse/collector'
require './lib/try_parse/expression'
require './lib/try_parse/sub_expression'
Dir['./lib/try_parse/*.rb'].each {|f| require f }

ast = SourceFile.new('working.js.jsx').to_ast
puts ast.inspect
