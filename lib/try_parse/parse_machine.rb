class ParseMachine
  def parse
    set_working
    loop do
      shift_char
      return return_value if @state == :done
      send("handle_#{@state}") rescue NoMethodError abort_parse
    end
  end

  def set_working
    @working = source.each_char.to_a
  end

  def shift_char
    @char = @working.shift
  end

  def abort_parse
    abort("can't recognize state #{@state}")
  end
end
