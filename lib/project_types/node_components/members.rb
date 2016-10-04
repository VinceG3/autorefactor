module NodeComponents
  class Members < Collection
    def find_member(tag)
      children.find do |member|
      	member.dig('key', 'name') == tag.to_s
      end
    end
  end
end