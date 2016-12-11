class Parser
  attr_reader :name, :type

  def initialize(file = nil, name:, type:)
    @file = file
    @name = name
    @type = type
  end

  def create(name:, type:)
    new(name: name, type: type).save
  end

  def save
    IO.write(filename, YAML.dump(self))
  end
end