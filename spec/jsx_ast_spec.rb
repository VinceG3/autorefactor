require 'spec_helper'

describe 'JsxAst' do
  subject { parse_source('react_component.jsx').parse }
  it 'inspects properly' do
    expect(subject.inspect).to eq(load_source('./react_component.jsxast'))
  end
end