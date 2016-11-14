class Separator < ParseMachine
  def snip
    sub_units << get_subclass.new(@sub_unit)
    set_next_state
  end

  def get_subclass
    self.class.const_get(ActiveSupport::Inflector.camelize(@state))
  end

  def set_next_state
    @state = parts[parts.find_index(@state) + 1]
    @state = :done if @state == nil
  end

  def resolve
    parse
    @sub_units.collect(&:resolve)
  end
end
