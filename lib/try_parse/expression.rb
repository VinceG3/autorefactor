class Expression < Classifier
  attr_reader :source, :sub_units

  def initialize(source)
    @source = source
    @state = :blank
    @sub_unit = ''
    @paren_count = 0
  end

  def handle_sub_unit
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

  def add_char
    @sub_unit << @char unless @char =~ /[;]/
  end

  def decrement_paren
    add_char
    @paren_count -= 1
    @state = :sub_unit if @paren_count < 0
  end

  def classified_expression
    case @type
    when :assignment
      Assignment.new(@sub_unit)
    when nil
      self
    else
      abort("#{self.class.name}: don't know what to do with type: #{@type.inspect}")
    end
  end

  def transform
    transformations.each(&:call)
  end

  def to_s
    sub_units.collect(&:to_s).join('')
  end

  def transformations
    [
      
    ]
  end

  def return_value
    classified_expression
  end

  def inspect
    "#{self.class.name}: #{source}"
  end

  def problems
    Rules.apply(self)
  end

  def resolve
    return self if @type.nil?
    classified_expression.resolve
  end
end