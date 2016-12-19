class Parser
  attr_reader :name, :type, :file, :project_name, :is_first, :classifiers

  def initialize(classifiers: [], name:, type:, project_name:, is_first: false)
    @name = name
    @type = type
    @classifiers = classifiers
    @project_name = project_name
    @is_first = is_first
  end

  def self.create(name:, type:, project:, is_first: false)
    new(name: name,
        type: type,
        project_name: project.name,
        is_first: !!is_first).save
  end

  def save
    IO.write(filename, YAML.dump(self))
  end

  def self.load(filename)
    YAML.load(IO.read(filename))
  end

  def project
    ProjectType.find_by_name(project_name)
  end

  def filename
    File.join('.', 'lib', 'project_types', project.name, "#{name}.parser")
  end

  def self.pick_new(project_type, is_first = false)
    $right.clear
    $right.para 'No parsers! Pick one:'
    buttons = $right.stack
    buttons.button('Collector') { make(project_type, :collector, is_first) }
    buttons.button('Separator') { make(project_type, :separator, is_first) }
    buttons.button('Classifier') { make(project_type, :classifier, is_first) }
    buttons.button('Terminal') { make(project_type, :terminal, is_first) }
    make(project_type, :collector, is_first) if $no_shoes
  end

  def self.empty?
    @parsers.empty?
  end

  def self.make(project, parser_type, is_first = false)
    name = $app.ask("Please name your new #{parser_type}") || 'collector'
    create(
      name: name,
      type: parser_type,
      project: project,
      is_first: is_first
    )
  end

  def parse_string(string)
    Parsing.new(self, string).call
  end

  def add_classifier
    project.classifiers.each do |classifier|
      buttons.button(classifier.name.demodulize) do |button|
        output.replace(classifier.name.demodulize)
      end
    end
  end
end
