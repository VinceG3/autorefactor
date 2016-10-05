class Ast
  attr_reader :expressions

  def initialize(expressions)
    @expressions = expressions
  end

  def transform!
    expressions.collect(&:transform)
  end

  def to_s
    expressions.collect(&:to_s).join('')
  end
end