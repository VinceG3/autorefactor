module Problems
  class AddClassifierProblem < Problem
    attr_reader :parser

    def initialize(parser)
      @parser = parser
    end

    def fix
      parser.select_classifier
    end
  end
end