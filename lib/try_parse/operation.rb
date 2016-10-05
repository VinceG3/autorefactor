class Operation
  attr_reader :type, :left, :right

  def initialize(type, left, right)
    @type = type
    @left = left
    @right = right
  end
end