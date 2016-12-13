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
    loop { iterate }
  end

  def iterate
    display
    if project_type.parsers.empty?
      Parser.pick_new(project_type, :first)
    else
      parsed = project_type.parse_text(IO.read(source))
      binding.pry
    end
  end
end