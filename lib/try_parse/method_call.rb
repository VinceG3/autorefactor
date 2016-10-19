class MethodCall < Collector
  def initialize(source)
    @source = source
    @expression = ''
    @working = source
    @state = :blank
    @expressions = []
    @paren_count = 0
  end

  def handle_blank
    case @char
    when /[\w]/
      add_char
    else
      what_next
    end
  end

  def resolve
    parse
    @sub_units = [
      Reciever.new(@sub_units[0]).resolve,
      MethodName.new(@sub_units[1]).resolve,
      Arguments.new(@sub_units[2]).resolve
    ]
  end
end