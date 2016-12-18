class Classifier
  ClassifierDirectory = './lib/classifiers'
  def self.all
    Classifiers.constants.collect do |sym|
      Classifiers.const_get(sym)
    end
  end
end