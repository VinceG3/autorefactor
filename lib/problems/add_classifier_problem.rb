module Problems
  class AddClassifierProblem < Problem
    attr_reader :parser

    def initialize(parser)
      @parser = parser
    end

    def fix
      $app.alert('hi')
      $right.clear
      stack = $right.stack
      stack.para "Classifier needed for #{parser.name}"
    end
  end
end