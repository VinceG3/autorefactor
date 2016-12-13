class ProjectType
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def parsers
    @parsers ||= load_parsers
  end

  def load_parsers
    dir = Dir['./lib/project_types/*'].grep(Regexp.new(name)).first
    files = Dir[File.join dir, '*.parser']
    @parsers = files.collect{|f| Parser.load(f) }
  end

  def self.find_by_name(name)
    all.find{|project| project.name == name }
  end

  def self.all
    dirs = Dir['./lib/project_types/*']
    binding.pry
  end
end