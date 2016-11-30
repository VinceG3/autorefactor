class SourceFile
  attr_reader :file, :source, :contents

  def initialize(file)
    @file = file
    @source = IO.read(file)
  end

  def parse
    file_extension = File.extname(file)
    ast_class = {
      '.jsx' => JsxAst,
      '.rb' => RbAst,
    }[file_extension]
    abort("add #{file_extension} to SourceFile") if ast_class.nil?
    @contents ||= ast_class.new(source).parse
  end
end