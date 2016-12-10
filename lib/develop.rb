class Develop
  attr_reader :test, :source
  def initialize(test)
    @test = test
    @source = test.source
  end

  def display
    source_text = IO.read(source)
    left = $app.flow(width: 700)
    right = $app.flow(width: 700)
    left.para(source_text, font: 'Inconsolata')
    next_char = source_text.each_char.to_a.first
    right.para("next char: #{next_char}", font: 'Inconsolata')
  end

  def iterate
    display
    load_parsers
    pick_new_parser
  end

  def load_parsers
    Dir['./lib/project_types/*'].grep(test.project_name)
  end
end