class NullClass
  def method_missing(*args)
    return self.class.new
  end
end