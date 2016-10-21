require 'spec_helper'

describe 'React Component' do
  subject { parse_source('react_component.jsx') }
  it 'parses to JSX AST' do
    expect(subject.parse).to be_a(JsxAst)
  end

  it 'has just one assignment' do
    expect(subject.contents.sub_units.count).to eq(1)
  end

  it 'uses React.createClass method call on the right side of the assignment'
  it 'exposes the name of the component'
  it 'has one object as the createClass arguments'
  it 'has a render method'
  it 'exposes the properties'
  it 'exposes the render method'
end
