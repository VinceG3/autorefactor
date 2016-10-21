class Collector < ParseMachine
  attr_reader :sub_units

  def initialize(source)
    @source = source
    @sub_unit = ''
    @working = source
    @state = :blank
    @sub_units = []
    @paren_count = 0
  end

  def snip
    @sub_units << collect_class.new(@sub_unit).parse
    @sub_unit = ''
    @state = :blank
  end
end
