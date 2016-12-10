class Test
  attr_reader :dir, :files, :output, :source
  def initialize(dir)
    @dir = dir
  end

  def self.run_all
    (Dir['./tests/*'] - Dir['./tests/*'].grep(/\.ignore/)).each do |format|
      Dir[File.join(format, '*')].each do |test|
        Test.new(test).run
      end
    end
  end

  def run
    @files = Dir[File.join(@dir, '*')].to_a
    @output = files.grep(/output/)
    @source = (files - output).first
    @output.empty? ? develop_test : run_complete
  end

  def develop_test
    Shoes.app do
      para 'hi'
      para @source.inspect
      para IO.read(@source)
    end
  end

  def run_complete
    parsed = SourceFile.new(source).parse.inspect.uncolorize
    if parsed == IO.read(output.first).uncolorize
      puts 'passed'
      return
    else
      Diff.new(parsed, IO.read(output.first).uncolorize).call
    end
  end
end