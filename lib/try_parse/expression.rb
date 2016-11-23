class Expression < Classifier
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
    when nil
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
    return Assignment.new(@sub_unit).parse if @has_equals
    if @has_dot
      return MethodCall.new(@sub_unit).parse if @has_paren
      return FunctionCall.new(@sub_unit).parse
    end
    return UnclassifiedExpression.new(@source).parse
  end

  def inspect(tab_count = 0)
    abort("Expression: inspect called on nil!") if @sub_unit.nil?
    "#{self.class.name.downcase.light_blue}: #{@sub_unit.inspect(tab_count + 1)}"
  end
end