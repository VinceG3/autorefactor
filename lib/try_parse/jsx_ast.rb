class JsxAst
  attr_reader :source, :contents

  def initialize(source)
    @source = source
  end

  def parse
    @contents ||= Expressions.new(source).parse
    self
  end

  def inspect
    "JSXAst:\n  contents: " << @contents.inspect(1)
  end
end