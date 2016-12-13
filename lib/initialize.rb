require 'active_support/core_ext/object/blank.rb'
require 'active_support/inflector'
require 'yaml'
require './lib/test'
require './lib/develop'
require './lib/parser'
require './lib/problem'
require './lib/parsing'
require './lib/project_type'

Dir['./lib/problems/*.rb'].each {|f| require f }
Dir['./lib/ruby/*.rb'].each {|f| require f }