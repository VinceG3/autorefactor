class Develop
  attr_reader :test, :source
  def initialize(test)
    @test = test
    @source = test.source
  end

  def project_type
    test.project_type
  end

  def display
    source_text = IO.read(source)
    $left.para(source_text, font: 'Inconsolata')
  end

  def iterate
    display
    binding.pry
    if project_type.parsers.empty?
      Parser.pick_new(:first)
    else
      parsed = Parser.find_containing(test).parse(source)
      $right.para 'iterating!'
    end
  end
end