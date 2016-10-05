class Printer
  attr_reader :ast

  def initialize(ast)
    @ast = ast
  end

  def self.print(ast)
    new(ast).print
  end

  def print
    ast.to_s
  end
end