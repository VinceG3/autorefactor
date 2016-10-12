class AssignTarget < Classifier
  def initialize(source)
    if source.is_a?(AssignTarget) 
      @source = source.source 
    else
      @source = source
    end
  end

  def inspect
    "#{self.class.name}: #{source}"
  end

  def resolve
    self
  end
end