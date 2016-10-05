class SubExpression < ParseMachine
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
      add_to_operation
    when /[.]/
      operation = Operation.new(@type, @left, @operation)
      @operations << operation
      @left = operation
      @state = :right
      @operation = ''
    when /[(]/
      @state = :paren
      add_to_operation
    when nil
      operation = Operation.new(@type, @left, @operation)
      @operations << operation
      @state = :done
      @operation = ''
    else
      what_next
    end
  end
  
  def handle_paren
    case @char
    when /[\w]/, /\s/
      add_to_operation
    when /[{]/, /[}]/
      add_to_operation
    when /[\[]/, /[\]]/
      add_to_operation
    when /[\/]/, /[-]/, /[“”]/
      add_to_operation
    when /[:;<!>&|"%*=$#?+',.]/
      add_to_operation
    when /[(]/
      add_to_operation
      @paren_count += 1
    when /[)]/
      decrement_paren
    else
      what_next
    end
  end

  def handle_blank
    case @char
    when /[\w]/
      add_to_operation
      @state = :operation
    else
      what_next
    end
  end

  def handle_operation
    case @char
    when /[\w]/
      add_to_operation
    when /[.]/
      @type = :message
      @state = :right
      @left = @operation
      @operation = ''
    else
      what_next
    end
  end

  def decrement_paren
    add_to_operation
    @paren_count -= 1
    @state = :right if @paren_count < 0
  end

  def add_to_operation
    @operation << @char
  end

  def to_s
    source
  end

  def what_next
    puts @working.join('')
                 .split("\n")
                 .take(10)
                 .join("\n")
    puts
    # puts "Current Expression: #{@expression}"
    puts "Current State:     #{@state}"
    puts "Current Operation: #{@operation}"
    # puts "Current Working:   #{@working.join('')}"
    puts "Current Character: #{@char.inspect}"
    abort
  end

  def return_value
    operations
  end

  def inspect
    parse
    "subexpression"
  end
end