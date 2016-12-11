class Parser
  attr_reader :name, :type, :file, :project

  def initialize(file = nil, name:, type:, project:)
    @file = file
    @name = name
    @type = type
    @project = project
  end

  def create(name:, type:)
    new(name: name, type: type).save
  end

  def save
    IO.write(filename, YAML.dump(self))
  end

  def filename
    File.join('.', 'lib', 'project_types', project, "#{name}.parser")
  end
end