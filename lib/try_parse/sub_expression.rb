class SubExpression < Classifier
  attr_reader :source, :operations

  def initialize(source)
    @source = source
    @operations = []
    @state = :blank
    @working = source
    @operation = ''
    @paren_count = 0
  end

  def handle_right
    case @char
    when /[\w]/
      add_char
    when /[.]/
      operation = Operation.new(@type, @left, @operation)
      @operations << operation
      @left = operation
      @state = :right
      @operation = ''
    when /[(]/
      @state = :paren
      @type = :method_call if @type == :property_accessor
      add_char
    when nil
      operation = Operation.new(@type, @left, @operation)
      @operations << operation
      @state = :done
      @operation = ''
    else
      what_next
    end
  end
  
  def handle_blank
    case @char
    when /[\w]/
      add_char
      @state = :operation
    else
      what_next
    end
  end

  def handle_operation
    case @char
    when /[\w]/
      add_char
    when /[.]/
      @type = :property_accessor
      @state = :right
      @left = @operation
      @operation = ''
    else
      what_next
    end
  end

  def decrement_paren
    add_char
    @paren_count -= 1
    @state = :right if @paren_count < 0
  end

  def add_char
    @operation << @char
  end

  def to_s
    source
  end

  def return_value
    operations
  end

  def inspect
    parse
    "subexpression"
  end

  def resolve
    parse
    classified_expression
  end

  def classified_expression
    case @type
    when :property_accessor
      PropertyAccessor.new(source)
    when :method_call
      MethodCall.new(source)
    when nil
      self
    else
      abort("unrecognized expression type: #{@type.inspect}")
    end
  end
end