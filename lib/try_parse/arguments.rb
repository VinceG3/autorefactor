class Arguments < Collector
  def initialize(source)
    @source = source
    @sub_units = []
    @state = :blank
    @sub_unit = ''
    @paren_count = 0
  end
end