class Parser
  attr_reader :name, :type, :file, :project, :is_first

  def initialize(file = nil, name:, type:, project:, is_first: false)
    @file = file
    @name = name
    @type = type
    @project = project
    @is_first = is_first
  end

  def self.create(name:, type:, project:, is_first: false)
    new(name: name, type: type, project: project).save
  end

  def save
    IO.write(filename, YAML.dump(self))
  end

  def self.load(filename)
    YAML.load(IO.read(filename))
  end

  def filename
    File.join('.', 'lib', 'project_types', project, "#{name}.parser")
  end

  def self.pick_new(is_first = false)
    $right.clear
    $right.para 'No parsers! Pick one:'
    buttons = $right.stack
    buttons.button('Collector') { make(:collector, is_first) }
    buttons.button('Separator') { make(:separator, is_first) }
    buttons.button('Classifier') { make(:classifier, is_first) }
    buttons.button('Terminal') { make(:terminal, is_first) }
    make(:collector, is_first)
  end

  def self.pick
    $right.clear
    parser_buttons = $right.stack
    parser_buttons.para 'Pick a parser or make a new one:'
    @parsers.each do |parser|
      parser_buttons.button(parser.name) { parser.iterate }
    end
    parser_buttons.button('New Parser') { pick_new }
  end

  def iterate
    $right.clear
    $right.para "Iterating #{name}"

  end

  def self.empty?
    @parsers.empty?
  end

  def self.make(parser_type, is_first = false)
    name = 'Expressions' # $app.ask("Please name your new #{parser_type}")
    create(
      name: name,
      type: parser_type,
      project: project_type,
      is_first: is_first
    )
  end

  def find_containing(test)

  end
end
