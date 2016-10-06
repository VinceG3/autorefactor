class Classification
  def self.classify(expression)
    all.collect{ |klass| klass.match(expression) }
  end

  def self.all
    [
      JSXComponent,
    ]
  end
end

Dir['./lib/try_parse/classifications/*.rb'].each {|f| require f }