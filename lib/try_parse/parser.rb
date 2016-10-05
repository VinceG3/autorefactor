class Parser
  attr_reader :source

  def initialize(source)
    @source = source
    @expression = ''
    @working = source
    @state = :blank
    @expressions = []
    @paren_count = 0
  end

  def parse
    @working = source.each_char.to_a
    loop do
      @char = @working.shift
      case @state
      when :blank
        handle_blank
      when :expression
        handle_expression
      when :paren
        handle_paren
      when :done
        parse_expressions
        break
      else
        what_next
      end
    end
    @expressions
  end

  def to_ast
    parse
    Ast.new(@expressions)
  end

  def handle_expression
    case @char
    when /[\w. =]/
      add_to_expression
    when /\(/
      add_parenthesized_expression
    when /[;]/
      snip_expression
    else
      what_next
    end
  end

  def handle_blank
    case @char
    when /[\w]/
      add_to_expression
      @state = :expression
    when /[\s]/
      return
    when nil
      @state = :done
    else
      what_next
    end
  end

  def handle_paren
    case @char
    when /[\w]/, /\s/
      add_to_expression
    when /[{]/, /[}]/
      add_to_expression
    when /[\[]/, /[\]]/
      add_to_expression
    when /[\/]/, /[-]/, /[“”]/
      add_to_expression
    when /[:;<!>&|"%*=$#?+',.]/
      add_to_expression
    when /[(]/
      add_to_expression
      @paren_count += 1
    when /[)]/
      decrement_paren
    else
      what_next
    end
  end

  def add_parenthesized_expression
    add_to_expression
    @state = :paren
  end

  def add_to_expression
    @expression << @char
  end

  def snip_expression
    add_to_expression
    @expressions << Expression.new(@expression)
    @expression = ''
    @state = :blank
  end

  def decrement_paren
    add_to_expression
    @paren_count -= 1
    @state = :expression if @paren_count < 0
  end

  def what_next
    puts @working.join('')
                 .split("\n")
                 .take(10)
                 .join("\n")
    puts
    # puts "Current Expression: #{@expression}"
    puts "Current State:     #{@state}"
    puts "Current Character: #{@char}"
    abort
  end

  def parse_expressions
    @expressions.collect(&:parse)
  end
end
