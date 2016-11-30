require 'active_support/inflector'

class AstNode
  attr_reader :json

  def initialize(json)
    @json = json
  end

  def inspect
    binding.pry
  end

  def self.component(*arguments)
    if arguments.first.class == Hash
      hash = arguments.first
      define_method(hash.keys.first) do
        get_component_hash(hash)
      end
    else
      define_method(arguments.first) do
        get_component_symbol(*arguments)
      end
    end
  end

  def get_component_hash(hash)
    method_name = hash.keys.first
    class_name = hash.delete(:class)
    class_name ||= ActiveSupport::Inflector.camelize(method_name)
    klass = NodeComponents.const_get(class_name)
    content_getter = hash.values.first
    component_object = send(content_getter)
    klass.new(component_object)
  end

  def get_component_symbol(*arguments)
    class_name = arguments.dig(1, :class)
    class_name ||= ActiveSupport::Inflector.camelize(arguments.first)
    klass = NodeComponents.const_get(class_name)
    content_getter = arguments.first.to_s.<<('_node').to_sym
    component_object = send(content_getter)
    klass.new(component_object)
  end
end
