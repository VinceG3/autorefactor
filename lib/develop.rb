class Develop
  def initialize(test)
    @test = test
    @source = test.source
  end

  def iterate
    source = IO.read(@source)
    left = $app.flow(width: 700)
    right = $app.flow(width: 700)
    left.para(source, font: 'Inconsolata')
    right.para(source.each_char.to_a.first, font: 'Inconsolata')
  end
end