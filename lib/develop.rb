class Develop
  attr_reader :test, :source, :left, :right
  def initialize(test)
    @test = test
    @source = test.source
    @left = $app.flow(width: 700)
    @right = $app.flow(width: 700)
  end

  def display
    source_text = IO.read(source)
    left.para(source_text, font: 'Inconsolata')
  end

  def iterate
    # loop do
      display
      load_parsers
      pick_new_parser
    # end
  end

  def load_parsers
    dir = Dir['./lib/project_types/*'].grep(Regexp.new(test.project_name)).first
    files = Dir[File.join dir, '*.parser']
    @parsers = files.collect{|f| Parser.load(f) }
  end

  def pick_new_parser
    if @parsers.empty?
      right.clear
      right.para 'No parsers! Pick one:'
      buttons = right.stack
      buttons.button('Collector') { new_parser(:collector) }
      buttons.button('Separator') { new_parser(:separator) }
      buttons.button('Classifier') { new_parser(:classifier) }
      buttons.button('Terminal') { new_parser(:terminal) }
    end
  end

  def new_parser(parser_type)
    name = ask("Please name your new #{parser_type}")
    Parser.create(name: name, type: parser_type, project: test.project_name)
  end
end