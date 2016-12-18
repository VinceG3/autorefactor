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
        stack.button classifier.name.demodulize {|argument| output.append(argument) }
      end
      output = stack.para
    end
  end
end