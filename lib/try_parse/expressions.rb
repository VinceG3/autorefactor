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

  def collect_class
    Expression
  end

  def inspect(tab_count = 0)
    "Expressions".light_blue << ": \n  " << "  " * tab_count <<
    @sub_units.collect{|su| su.inspect(tab_count + 1)}.join
  end
end