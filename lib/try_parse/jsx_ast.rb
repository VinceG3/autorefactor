class JsxAst
  attr_reader :source, :contents

  def initialize(source)
    @source = source
  end

  def parse
    @contents ||= Expressions.new(source).parse
    self
  end
end