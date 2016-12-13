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

  def loop_until_finished
    retval = nil
    until retval == :finished
      retval = iterate
    end
  end

  def iterate
    display
    binding.pry
    if project_type.parsers.empty?
      Parser.pick_new(project_type, :first)
    else
      binding.pry
      parsed = Parser.find_containing(test).parse(source)
    end
  end
end