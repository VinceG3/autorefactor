class MethodCall < Separator
  def initialize(source)
    @source = source
    @expression = ''
    @working = source
    @state = :receiver
    @expressions = []
    @paren_count = 0
    @sub_unit = ''
    @sub_units = []
  end

  def parts
    [:receiver, :method_name, :arguments]
  end

  def handle_receiver
    case @char
    when /[\w]/
      add_char
    when /[.]/
      snip
    else
      what_next
    end
  end

  def handle_method_name
    case @char
    when /[\w]/
      add_char
    when /[(]/
      snip
    else
      what_next
    end
  end

  def handle_arguments
    case @char
    when /[^()]/
      add_char
    when /[(]/
      add_char
      @paren_count += 1
    when /[)]/
      return snip if @paren_count == 0
      add_char
      @paren_count -= 1
    else
      what_next
    end
  end

  def inspect(tab_count = 0)
    ""
  end
end