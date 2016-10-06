class Expression < Classifier
  attr_reader :source, :sub_exprs

  def initialize(source)
    @source = source
    @state = :blank
    @sub_expr = ''
    @paren_count = 0
  end

  def handle_sub_expr
    case @char
    when /[\w.]/
      add_char
    when / /
      add_char
    when /[=]/
      @type = :assignment
      add_char
    when /[(]/
      add_parenthesized_expression
    when /[;]/
      snip
      @state = :done
    else
      what_next
    end
  end

  def handle_blank
    case @char
    when /[\w]/
      @state = :sub_expr
      add_char
    when /[=]/
      raise SyntaxError unless sub_exprs.count == 1
      @type = :assignment
      add_char
    when /[\s]/
    else
      what_next
    end
  end

  def add_parenthesized_expression
    add_char
    @state = :paren
  end

  def snip
    add_char unless @char =~ /[; ]/
    sub_exprs << SubExpression.new(@sub_expr)
    @sub_expr = ''
    @state = :blank
  end

  def add_char
    @sub_expr << @char unless @char =~ /[;]/
  end

  def decrement_paren
    add_char
    @paren_count -= 1
    @state = :sub_expr if @paren_count < 0
  end

  def what_next
    puts @working.join('')
                 .split("\n")
                 .take(10)
                 .join("\n")
    puts
    puts "Current State:     #{@state}"
    puts "Current Character: #{@char}"
    # binding.pry
    abort
  end

  def classified_expression
    case @type
    when :assignment
      binding.pry
      Assignment.new
    else
      binding.pry
    end
  end

  def transform
    transformations.each(&:call)
  end

  def to_s
    sub_exprs.collect(&:to_s).join('')
  end

  def transformations
    [
      
    ]
  end

  def return_value
    classified_expression
  end

  def inspect
    classified_expression.inspect
  end

  def problems
    Rules.apply(self)
  end

  def resolve
    sub_exprs.collect(&:resolve)
    classified_expression
  end
end