require 'active_support/core_ext/object/blank.rb'
require 'active_support/inflector'
require 'yaml'
require './lib/test'
require './lib/parser'
require './lib/window'
require './lib/develop'
require './lib/problem'
require './lib/parsing'
require './lib/classifier'
require './lib/project_type'

Dir['./lib/problems/*.rb'].each {|f| require f }
Dir['./lib/ruby/*.rb'].each {|f| require f }
Dir['./lib/classifiers/*.rb'].each {|f| require f }