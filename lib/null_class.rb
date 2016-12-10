class NullClass
  def method_missing
    return self.class.new
  end
end