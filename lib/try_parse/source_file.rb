class SourceFile
  attr_reader :file, :source, :ast

  def initialize(file)
    @file = file
    @source = IO.read(file)
  end

  def expressions
    Parser.new(source).to_ast
  end

  def call
    @ast ||= expressions
  end

  def render
    call
    Printer.print(@ast)
  end

  def transform
    call
    ast.transform!
  end
end
