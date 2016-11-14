class UnclassifiedExpression
  attr_reader :source
  def initialize(source)
    @source = source
  end

  def resolve
    self
  end

  def inspect(tab_count = 0)
    "#{self.class.name.light_blue}: #{source}"
  end
end