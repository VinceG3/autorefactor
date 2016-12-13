class NullClass
  def method_missing(*args)
    return self.class.new
  end

  def para(string)
    puts string
  end
end