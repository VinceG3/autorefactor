module Problems
  class AddClassifierProblem < Problem
    def initialize(parser)
      @parser = parser
    end

    def fix
      $right.clear
      stack = $right.stack
      stack.para "Classifier needed for #{parser.name}"
    end
  end
end