class Develop
  attr_reader :test, :source
  def initialize(test)
    @test = test
    @source = test.source
    $left = $app.flow(width: 700)
    $right = $app.flow(width: 400)
  end

  def display
    source_text = IO.read(source)
    $left.para(source_text, font: 'Inconsolata')
  end

  def iterate
    display
    Parser.load_all(test)
    if Parser.empty?
      Parser.pick_new(:first)
    else
      parsed = Parser.find_containing(test).parse(source)
    end
  end
end