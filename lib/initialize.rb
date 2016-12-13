require 'active_support/core_ext/object/blank.rb'
require 'active_support/inflector'
require 'yaml'
require './lib/diff'
require './lib/test'
require './lib/develop'
require './lib/parser'
require './lib/problem'
require './lib/parsing'
require './lib/what_next'
require './lib/ast_node'
require './lib/source_file'
require './lib/project_type'

Dir['./lib/problems/*.rb'].each {|f| require f }
Dir['./lib/try_parse/*.rb'].each {|f| require f }
Dir['./lib/ruby/*.rb'].each {|f| require f }