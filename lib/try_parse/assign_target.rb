class AssignTarget < Classifier
  def initialize(source)
    if source.is_a?(AssignTarget) 
      @source = source.source 
    else
      @source = source
    end
  end

  def classify
    @classified_expression ||= self
  end

  def inspect
    "#{self.class.name.light_blue}: #{source}"
  end

  def resolve
    self
  end
end