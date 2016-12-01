class Test
  attr_reader :dir, :files, :output, :source
  def initialize(dir)
    @dir = dir
  end

  def self.run_all!
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
    require 'flammarion'
    left_pane = Flammarion::Engraving.new
    left_pane.orientation = :horizontal
    right_pane = left_pane.pane(:right)

    left_pane.subpane('title').puts('Source:')
    left_pane.puts IO.read(@source)
    parsed = SourceFile.new(source).parse.inspect.uncolorize
    
    right_pane.subpane('title').puts('Parsed:')
    right_pane.puts parsed
    
    left_pane.wait_until_closed
    abort
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