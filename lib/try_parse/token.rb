class Token
  attr_reader :source

  def initialize(source)
    @source = source
  end

  def resolve
    source
  end

  def inspect
    source
  end
end