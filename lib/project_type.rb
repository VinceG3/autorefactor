class ProjectType
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def self.parsers
    @parsers ||= load_parsers
  end

  def self.load_parsers(test)
    dir = Dir['./lib/project_types/*'].grep(Regexp.new(name)).first
    files = Dir[File.join dir, '*.parser']
    @parsers = files.collect{|f| Parser.load(f) }
  end
end