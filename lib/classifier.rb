class Classifier
  ClassifierDirectory = './lib/classifiers'
  def self.all
    Dir[File.join(ClassifierDirectory, '*.rb')].
  end
end