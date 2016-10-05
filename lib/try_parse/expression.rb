class Expression
  attr_reader :source, :sub_exprs

  def initialize(source)
    @source = source
    @state = :blank
    @sub_expr = ''
    @sub_exprs = []
    @paren_count = 0
  end

  def parse
    @working = source.each_char.to_a
    loop do
      @char = @working.shift
      case @state
      when :blank
        handle_blank
      when :sub_expr
        handle_sub_expr
      when :paren
        handle_paren
      when :done
        return classified_expression
      else
        what_next
      end
    end
  end

  def handle_sub_expr
    case @char
    when /[\w.]/
      add_to_sub_expr
    when / /
      snip_sub_expr
    when /[(]/
      add_parenthesized_expression
    when /[;]/
      snip_sub_expr
      @state = :done
    else
      what_next
    end
  end

  def handle_blank
    case @char
    when /[\w]/
      @state = :sub_expr
      add_to_sub_expr
    when /[=]/
      raise SyntaxError unless sub_exprs.count == 1
      @type = :assignment
    when /[\s]/
    else
      what_next
    end
  end

  def handle_paren
    case @char
    when /[\w]/, /\s/
      add_to_sub_expr
    when /[{]/, /[}]/
      add_to_sub_expr
    when /[\[]/, /[\]]/
      add_to_sub_expr
    when /[\/]/, /[-]/, /[“”]/
      add_to_sub_expr
    when /[:;<!>&|"%*=$#?+',.]/
      add_to_sub_expr
    when /[(]/
      add_to_sub_expr
      @paren_count += 1
    when /[)]/
      decrement_paren
    else
      what_next
    end
  end

  def add_parenthesized_expression
    add_to_sub_expr
    @state = :paren
  end

  def snip_sub_expr
    add_to_sub_expr unless @char =~ /[; ]/
    sub_exprs << SubExpression.new(@sub_expr)
    @sub_expr = ''
    @state = :blank
  end

  def add_to_sub_expr
    @sub_expr << @char unless @char =~ /[;]/
  end

  def decrement_paren
    add_to_sub_expr
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
      Assignment.new(*sub_exprs)
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

  def inspect
    classified_expression.inspect
  end

  def problems
    Rules.apply(self)
  end
end