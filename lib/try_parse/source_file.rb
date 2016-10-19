class SourceFile
  attr_reader :file, :source, :contents

  def initialize(file)
    @file = file
    @source = IO.read(file)
  end

  def parse
    file_extension = File.extname(file)
    @contents ||= {
      '.jsx' => JsxAst
    }[file_extension].new(source).parse
  end
end