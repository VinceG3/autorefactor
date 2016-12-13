class ProjectType
  attr_reader :name

  ProjectsDirectory = './lib/project_types'

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

  def self.dirs
    Dir['./lib/project_types/*']
  end

  def self.all
    dirs
      .collect{|d| d.match(/\w+$/)[0] }
      .collect{|n| ProjectType.new(n) }
  end

  def parse_text(string)
    first_parser.parse_string(string)
  end

  def first_parser
    parsers.find{|p| p.is_first == true }
  end
end