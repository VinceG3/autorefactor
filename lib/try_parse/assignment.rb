class Assignment < Collector
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

  def snip
    if @sub_units.empty?
      @sub_units << Reference.new(@sub_unit).parse
    else
      @sub_units << Expression.new(@sub_unit).parse
    end
    @sub_unit = ''
    state = :blank
  end

  def add_char
    @sub_unit << @char
  end

  def inspect(tab_value = 0)
    "#{self.class.name.light_blue}:\n" <<
    "  " * (tab_value) << "target: #{@sub_units[0].inspect(tab_value + 1)}\n" <<
    "  " * (tab_value) << "contents: #{@sub_units[1].inspect(tab_value + 1)}"
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