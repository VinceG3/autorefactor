class Classifier
  ClassifierDirectory = './lib/classifiers'
  def self.all
    Classifiers.constants.each do |sym|
      binding.pry
    end
  end
end