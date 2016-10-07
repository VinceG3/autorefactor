class AssignTarget < Classifier
  def initialize(source)
    @source = source
  end

  def inspect
    "#{self.class.name}: #{source}"
  end

  def resolve
    self
  end
end