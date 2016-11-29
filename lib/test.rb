class Test
  def initialize(dir)
    @dir = dir
  end

  def self.run_all!
    Dir['./tests/*'].each do |format|
      Dir[File.join(format, '*')].each do |test|
        Test.new(test).run
      end
    end
  end

  def run
    files = Dir[File.join(@dir, '*')].to_a
    output = files.grep(/output/)
    source = (files - output).first
    parsed = SourceFile.new(source).parse.inspect.uncolorize
    if parsed == IO.read(output.first).uncolorize
      puts 'passed'
      return
    else
      Diff.new(parsed, IO.read(output.first).uncolorize).call
    end
  end
end