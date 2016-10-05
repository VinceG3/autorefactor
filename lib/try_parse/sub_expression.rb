class SubExpression
  attr_reader :source

  def initialize(source)
    @source = source
    @operations = []
    @state = :blank
    @working = source
    @operation = ''
  end

  def parse
    @working = source.each_char.to_a
    loop do
      @char = @working.shift
      case @state
      when :blank
        handle_blank
      when :operation
        handle_operation
      when :right
        handle_right
      when :done
        break
      else
        what_next
      end
    end
    @operations
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

  def inspect
    parse
    "subexpression"
  end
end