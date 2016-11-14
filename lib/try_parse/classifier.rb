class Classifier < ParseMachine
  attr_reader :source, :sub_units

  def initialize(source)
    @source = source.is_a?(String) ? source : source.source
    @state = :blank
    @sub_unit = ''
    @paren_count = 0
  end

  def classify
    @sub_unit = get_classified_value
  end
end
