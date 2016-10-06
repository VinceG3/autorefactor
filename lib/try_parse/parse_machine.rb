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
    binding.pry
    abort("can't recognize state #{@state}")
  end

  def handle_paren
    case @char
    when /[\w]/, /\s/
      add_char
    when /[{]/, /[}]/
      add_char
    when /[\[]/, /[\]]/
      add_char
    when /[\/]/, /[-]/, /[“”]/
      add_char
    when /[:;<!>&|"%*=$#?+',.]/
      add_char
    when /[(]/
      add_char
      @paren_count += 1
    when /[)]/
      decrement_paren
    else
      what_next
    end
  end

  def what_next
    puts @working.join('')
                 .split("\n")
                 .take(10)
                 .join("\n")
    puts
    puts "Current State:     #{@state}"
    puts "Current Operation: #{@operation}"
    puts "Current Character: #{@char.inspect}"
    abort
  end
end