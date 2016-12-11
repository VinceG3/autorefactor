class Develop
  attr_reader :test, :source, :left, :right
  def initialize(test)
    @test = test
    @source = test.source
    @left = $app.flow(width: 700)
    @right = $app.flow(width: 400)
  end

  def display
    source_text = IO.read(source)
    left.para(source_text, font: 'Inconsolata')
  end

  def iterate
    # loop do
      display
      load_parsers
      @parsers.empty? ? pick_new_parser : pick_parser
    # end
  end

  def load_parsers
    dir = Dir['./lib/project_types/*'].grep(Regexp.new(test.project_name)).first
    files = Dir[File.join dir, '*.parser']
    @parsers = files.collect{|f| Parser.load(f) }
  end

  def pick_new_parser
    right.clear
    right.para 'No parsers! Pick one:'
    buttons = right.stack
    buttons.button('Collector') { new_parser(:collector) }
    buttons.button('Separator') { new_parser(:separator) }
    buttons.button('Classifier') { new_parser(:classifier) }
    buttons.button('Terminal') { new_parser(:terminal) }
  end

  def pick_parser
    right.clear
    parser_buttons = right.stack
    parser_buttons.para 'Pick a parser or make a new one:'
    @parsers.each do |parser|
      parser_buttons.button(parser.name) { iterate_parser(parser) }
    end
    parser_buttons.button('New Parser') { pick_new_parser }
  end

  def iterate_parser(parser)
    right.clear
    right.para "Iterating #{parser.name}"
  end

  def new_parser(parser_type, name = nil)
    name = $app.ask("Please name your new #{parser_type}") if name.nil?
    Parser.create(name: name, type: parser_type, project: test.project_name)
  end
end