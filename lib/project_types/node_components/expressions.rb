module NodeComponents
  class Expressions < Collection
    def find_member(tag)
      children.find do |member|
        member['type'] == 'ReturnStatement'
      end
    end
  end
end