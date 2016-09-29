module NodeComponents
  class Members < Collection
    def find_member(tag)
      children.find{|member| member.dig('key', 'name') == tag.to_s }
    end
  end
end