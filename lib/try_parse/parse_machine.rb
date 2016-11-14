class ParseMachine
  attr_reader :source
  
  def parse
    set_working
    loop do
      shift_char
      if @state == :done
        classify if self.respond_to?(:classify)
        return self
      end
      if respond_to?("handle_#{@state}")
        send("handle_#{@state}") 
      else
        abort_parse
      end
    end
  end

  def sub_units
    abort("no @sub_units declared on #{self.class.name}!") unless instance_variable_defined?(:@sub_units)
    @sub_units
  end

  def sub_unit
    abort("no @sub_unit declared on #{self.class.name}!") unless instance_variable_defined?(:@sub_unit)
    @sub_unit
  end

  def set_working
    @working = source.each_char.to_a
  end

  def shift_char
    @char = @working.shift
  end

  def abort_parse
    abort("#{self.class.name}: can't recognize state #{@state.inspect}")
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

  def add_char
    sub_unit << @char
  end

  def decrement_paren
    add_char
    @paren_count -= 1
    @state = :sub_unit if @paren_count < 0
  end

  def what_next
    puts "In: #{self.class.name}"
    puts
    puts @working.join('')
                 .split("\n")
                 .take(10)
                 .join("\n")
    puts
    puts "Current State:     #{@state}"
    puts "Current Sub unit : #{sub_unit}"
    puts "Current Character: #{@char.inspect}"
    abort
  end
end