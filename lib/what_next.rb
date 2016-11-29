class WhatNext
  def initialize(parse_machine)
    @parse_machine = parse_machine
  end

  def call
    string = ""
    string += "In: #{@parse_machine.class.name}\n\n"
    string += @parse_machine.working
                            .join('')
                            .split("\n")
                            .take(10)
                            .join("\n")
    string += "Current State:     #{@parse_machine.state}\n"
    string += "Current Sub unit : #{@parse_machine.sub_unit}\n"
    string += "Current Character: #{@parse_machine.char.inspect}\n"
    open_window(string)
    abort
  end

  def open_window(string)
    require 'flammarion'
    f = Flammarion::Engraving.new
    f.puts string
    f.wait_until_closed
  end
end