class Diff
  attr_reader :actual, :expected

  def initialize(actual, expected)
    @actual, @expected = actual, expected
  end

  def call
    expected.each_line.zip(actual.each_line).each do |expected, actual|
      if expected == actual
        puts expected.chomp.blue
      else
        puts expected.chomp.green
        puts actual.chomp.red
        break
      end
    end
  end
end