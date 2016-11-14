class Reference < Terminal
  def inspect(tab_value = 0)
    "Reference: #{source}"
  end

  def handle_blank
    case @char
    when /[\w]/
      add_char
    when /[.]/
      add_char
    when nil
      @state = :done
    else
      what_next
    end
  end
end