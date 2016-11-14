class Terminal
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

  def parse
    
  end
end