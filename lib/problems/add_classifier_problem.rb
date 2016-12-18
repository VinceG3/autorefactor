module Problems
  class AddClassifierProblem < Problem
    attr_reader :parser

    def initialize(parser)
      @parser = parser
    end

    def fix
      $right.clear
      stack = $right.stack
      message = stack.para
      buttons = stack.stack
      output = stack.para
      message.replace "Classifier needed for #{parser.name}"
      parser.project.classifiers.each do |classifier|
        buttons.button(classifier.name.demodulize) {|argument| output.replace(argument) }
      end
    end
  end
end