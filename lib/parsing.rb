class Parsing
  attr_reader :parser, :string

  def initialize(parser, string)
    @parser = parser
    @string = string
  end

  def call
    return Problems::AddClassifierProblem.new(parser) if parser.classifiers.empty?
  end
end