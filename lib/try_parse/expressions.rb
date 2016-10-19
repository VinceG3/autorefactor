class Expressions < Collector
  def handle_blank
    case @char
    when /[\w]/
      add_char
      @state = :sub_unit
    when /[\n]/
    when nil
      @state = :done
    else
      what_next
    end
  end

  def handle_sub_unit
    case @char
    when /[\w =]/, /[.]/
      add_char
    when /[(]/
      add_char
      @state = :paren
    when /[;]/
      snip
    else
      what_next
    end
  end
end