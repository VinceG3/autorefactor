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
    display
    load_parsers
    pick_new_parser
  end

  def load_parsers
    dir = Dir['./lib/project_types/*'].grep(Regexp.new(test.project_name)).first
    files = Dir[File.join dir, '*.parser']
    @parsers = files.collect{|f| Parser.load(f) }
  end

  def pick_new_parser
    if @parsers.empty?
      buttons =  right.stack
      buttons.button('Collector')
      buttons.button('Separator')
      buttons.button('Classifier')
      buttons.button('Terminal')
    end
  end
end