class Assignment
  attr_reader :left, :right

  def initialize(left, right)
    @left = left
    @right = right
  end

  def to_s
    "#{left} = #{right}"
  end
end