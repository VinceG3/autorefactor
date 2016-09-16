class ComponentFile
  attr_reader :string


  def initialize(string)
    @string = string
  end

  def get_component
    Component.find_from_string(string)
  end

  class Component
    def self.find_from_string(string)
      binding.pry
    end

    def name
      
    end
  end
end

component_file = ComponentFile.new(IO.read('test_component.js.jsx'))
component.get_component.name
