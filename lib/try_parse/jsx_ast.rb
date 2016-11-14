class JsxAst
  attr_reader :source, :contents

  def initialize(source)
    @source = source
  end

  def parse
    @contents ||= Expressions.new(source).parse
    self
  end

  def inspect(tab_value = 0)
    "JsxAst:\n" <<
    "  " * (tab_value + 1) << "contents: " << @contents.inspect(1)
  end
end