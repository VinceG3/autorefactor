require 'spec_helper'

describe 'JsxAst' do
  subject { parse_source('component.jsx').parse }
  it 'inspects properly' do
    expect(subject.inspect.uncolorize).to eq(load_source('component.jsxast'))
  end
end