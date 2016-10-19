class Expression < Classifier
  attr_reader :source, :sub_units

  def initialize(source)
    @source = source.is_a?(String) ? source : source.source
    @state = :blank
    @sub_unit = ''
    @paren_count = 0
  end

  def handle_sub_unit
    case @char
    when /[\w]/
      add_char
    when / /
      add_char
    when /[=]/
      @has_equals = true
      add_char
    when /[.]/
      @has_dot = true
      add_char
    when /[(]/
      @has_paren = true
      add_char
      @state = :paren
    when /[;]/
      @state = :done
    else
      what_next
    end
  end

  def handle_blank
    case @char
    when /[\w]/
      @state = :sub_unit
      add_char
    when /[=]/
      raise SyntaxError unless sub_units.count == 1
      @has_equals = true
      add_char
    when /[\s]/
    else
      what_next
    end
  end

  def get_classified_value
    return Assignment.new(@sub_unit) if @has_equals
    if @has_dot
      return MethodCall.new(@sub_unit) if @has_paren
      return FunctionCall.new(@sub_unit)
    end
    return UnclassifiedExpression.new(@source)
  end

  def classify
    @classified_value ||= get_classified_value
  end

  def to_s
    return '' if sub_units.blank?
    sub_units.collect(&:to_s).join('')
  end

  def return_value
    classify
  end

  def inspect
    "#{self.class.name.light_blue}: #{@classified_expression.source}"
  end

  def problems
    Rules.apply(self)
  end

  def resolve
    classify.resolve
  end
end