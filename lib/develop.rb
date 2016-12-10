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
    next_char = source.each_char.to_a.first
    right.para("next char: #{next_char}", font: 'Inconsolata')
  end
end