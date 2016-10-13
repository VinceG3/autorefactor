class FunctionCall < Classifier
  def initialize(source)
    @source = source.is_a?(String) ? source : source.source
    @state = :blank
    @sub_unit = ''
    @paren_count = 0
  end

  def resolve
    return self if @type.nil?
    classify.resolve
  end

  def inspect
    "#{self.class.name.light_blue}: #{source}"
  end
end