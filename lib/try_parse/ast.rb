class Ast
  attr_reader :expressions

  def initialize(expressions)
    @expressions = expressions
  end

  def transform!
    expressions.collect(&:transform)
  end

  def resolve
    @expressions = expressions.collect(&:resolve)
    self
  end

  def lint
    resolve
    expressions.collect(&:problems)
  end

  def to_s
    expressions.collect(&:to_s).join('')
  end

  def render
    Printer.print(expressions)
  end

  def inspect
    "ast: #{expressions.collect(&:inspect).join}"
  end
end
