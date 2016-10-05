class SubExpression
  attr_reader :source

  def initialize(source)
    @source = source
  end

  def to_s
    source
  end
end