class Rules
  def self.apply(expression)
    puts "Expression: #{expression.inspect}"

    types = Classification.classify(expression)
    types.each do |type|
      type.rules.each do |rule|
        rule.apply(expression)
      end
    end
  end
end