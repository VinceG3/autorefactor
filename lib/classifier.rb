class Classifier
  ClassifierDirectory = './lib/classifiers'
  def self.all
    Dir[File.join(ClassifierDirectory, '*.rb')].each do |f|
      binding.pry
    end
  end
end