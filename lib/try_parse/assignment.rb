class Assignment < Collector
  attr_reader :source

  def initialize(source)
    @source = source
    @sub_units = []
    @state = :blank
    @sub_unit = ''
    @paren_count = 0
  end

  def handle_blank
    case @char
    when /[\w]/
      add_char
    when /[.]/
      add_char
    when / /
    when /[=]/
      snip
    when /[(]/
      add_char
      @state = :paren
    when nil
      snip
      @state = :done
    else
      what_next
    end
  end

  def resolve
    parse
    @sub_units = [
      AssignTarget.new(@sub_units[0]).resolve,
      Expression.new(@sub_units[1]).resolve,
    ]
    self
  end

  def snip
    @sub_units << @sub_unit
    @sub_unit = ''
    state = :blank
  end

  def add_char
    @sub_unit << @char
  end

  def inspect
    "#{self.class.name}:\n#{@sub_units[0].inspect}\n#{@sub_units[1].inspect}"
  end

  def return_value
    self
  end

  def decrement_paren
    add_char
    @paren_count -= 1
    @state = :blank if @paren_count < 0
  end
end