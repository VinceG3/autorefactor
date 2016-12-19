class NullClass
  def method_missing(*args)
    return self.class.new
  end

  def para(string = '', *options)
    puts string
  end

  def ask(string)
    return 'test_string'
  end

  def button(name)
    puts "button: #{name}"
  end
end