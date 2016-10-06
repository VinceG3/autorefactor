class Parser < Collector
  attr_reader :source

  def initialize(source)
    @source = source
    @expression = ''
    @working = source
    @state = :blank
    @expressions = []
    @paren_count = 0
  end

  def to_ast
    parse
    Ast.new(@expressions)
  end

  def handle_expression
    case @char
    when /[\w. =]/
      add_char
    when /\(/
      add_parenthesized_expression
    when /[;]/
      snip
    else
      what_next
    end
  end

  def handle_blank
    case @char
    when /[\w]/
      add_char
      @state = :expression
    when /[\s]/
      return
    when nil
      @state = :done
    else
      what_next
    end
  end

  def add_parenthesized_expression
    add_char
    @state = :paren
  end

  def add_char
    @expression << @char
  end

  def snip
    add_char
    @expressions << Expression.new(@expression)
    @expression = ''
    @state = :blank
  end

  def decrement_paren
    add_char
    @paren_count -= 1
    @state = :expression if @paren_count < 0
  end

  def parse_expressions
    @expressions.collect(&:parse)
  end

  def return_value
    parse_expressions
  end
end
