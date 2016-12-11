class Parser
  attr_reader :name, :type, :file, :project

  def initialize(file = nil, name:, type:, project:)
    @file = file
    @name = name
    @type = type
    @project = project
  end

  def self.create(name:, type:, project:)
    new(name: name, type: type, project: project).save
  end

  def save
    IO.write(filename, YAML.dump(self))
  end

  def self.load(filename)

  end

  def filename
    File.join('.', 'lib', 'project_types', project, "#{name}.parser")
  end
end