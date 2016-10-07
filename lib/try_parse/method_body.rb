class MethodBody
  attr_reader :file, :source, :ast

  def initialize(source)
    @source = source
  end

  def expressions
    ast.expressions
  end

  def call
    @ast ||= Parser.new(source).to_ast.resolve
    self
  end

  def to_ast
    call.ast
  end

  def render
    call
    ast.to_s
  end

  def lint
    call
    ast.lint
  end

  def transform
    call
    ast.transform!
  end
end
