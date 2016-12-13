class Parser
  attr_reader :name, :type, :file, :project, :is_first

  def initialize(file = nil, name:, type:, project_name:, is_first: false)
    @file = file
    @name = name
    @type = type
    @project_name = project_name
    @is_first = is_first
  end

  def self.create(name:, type:, project:, is_first: false)
    $right.clear
    stack = $right.stack
    stack.para "Creating!"
    stack.para "name: #{name}"
    stack.para "type: #{type}"
    stack.para "project: #{project}"
    stack.para "is_first: #{is_first}"
    new(name: name, type: type, project_name: project.name).save
  end

  def save
    $app.alert('saving!')
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

  # def self.pick
  #   $right.clear
  #   parser_buttons = $right.stack
  #   parser_buttons.para 'Pick a parser or make a new one:'
  #   @parsers.each do |parser|
  #     parser_buttons.button(parser.name) { parser.iterate }
  #   end
  #   parser_buttons.button('New Parser') { pick_new }
  # end

  def iterate
    $right.clear
    $right.para "Iterating #{name}"

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

  def find_containing(test)

  end
end
