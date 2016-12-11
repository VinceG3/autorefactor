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
    YAML.load(IO.read(filename))
  end

  def filename
    File.join('.', 'lib', 'project_types', project, "#{name}.parser")
  end

  def self.pick_new
    right.clear
    right.para 'No parsers! Pick one:'
    buttons = right.stack
    buttons.button('Collector') { new_parser(:collector) }
    buttons.button('Separator') { new_parser(:separator) }
    buttons.button('Classifier') { new_parser(:classifier) }
    buttons.button('Terminal') { new_parser(:terminal) }
  end

  def self.pick
    right.clear
    parser_buttons = right.stack
    parser_buttons.para 'Pick a parser or make a new one:'
    @parsers.each do |parser|
      parser_buttons.button(parser.name) { iterate_parser(parser) }
    end
    parser_buttons.button('New Parser') { pick_new_parser }
  end

  def iterate
    right.clear
    right.para "Iterating #{name}"
  end

  def self.load_all(test)
    dir = Dir['./lib/project_types/*'].grep(Regexp.new(test.project_name)).first
    files = Dir[File.join dir, '*.parser']
    @parsers = files.collect{|f| load(f) }
  end

  def self.make(parser_type, name = nil)
    name = $app.ask("Please name your new #{parser_type}") if name.nil?
    Parser.create(name: name, type: parser_type, project: test.project_name)
  end
end
