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
      Parser.load_all
      @parsers.empty? ? Parser.pick_new : Parser.pick
    # end
  end
end