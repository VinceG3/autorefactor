class SourceFile
  attr_reader :file, :source, :ast

  def initialize(file)
    @file = file
    @source = IO.read(file)
  end

  def expressions
    ast.expressions
  end

  def call
    @ast ||= MethodBody.new(source).to_ast.resolve
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