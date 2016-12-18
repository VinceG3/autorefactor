module Problems
  class AddClassifierProblem < Problem
    attr_reader :parser

    def initialize(parser)
      @parser = parser
    end

    def fix
      $right.clear
      stack = $right.stack
      stack.para "Classifier needed for #{parser.name}"
      parser.project.classifiers.each do |classifier|
        stack.button classifier.name.demodulize {|argument| $app.alert(argument) }
      end
    end
  end
end