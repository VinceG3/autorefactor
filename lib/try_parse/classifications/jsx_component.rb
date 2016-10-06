class JSXComponent < Classification
  def self.match(assignment)
    assignment.is_a?(Assignment)
    assignment.right.is_a?(MethodCall)
    assignment.right.receiver.name == "React"
    assignment.right.method_name == "createClass"
  end
end
