class Assignment < Separator
  def initialize(source)
    @source = source
    @sub_units = []
    @state = :target
    @sub_unit = ''
    @paren_count = 0
  end

  def parts
    [:target, :contents]
  end

  def target_state
    {
      /[\w]/ => :add_char,
      /[=]/ => :snip,
      /[ ]/ => :noop,
      /[.]/ => :add_char,
    }
  end

  def contents_state
    {
      Word => :add_char,
      Semicolon => :snip,
      Space => :noop
    }
  end

  def handle_target
    send_match(target_state)
  end

  def handle_contents
    send_match(contents_state)
  end

  def send_match(hash)
    meth = hash.find {|k,v| k.match(@char) }
    what_next if meth.nil?
    return if meth[1] == :noop
    send(meth[1])
  end
end