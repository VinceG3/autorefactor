require 'spec_helper'

def parse_source(filename)
  path = "./spec/#{filename}"
  SourceFile.new(path).parse
end

def load_source(filename)
  path = "./spec/#{filename}"
  IO.read(path)
end

describe 'JSX Component' do
  subject { parse_source('jsx_component.jsx') }
  it 'parses to JSX AST' do
    expect(subject.parse).to be_a(JsxAst)
  end
end

describe 'JsxAst' do
  subject { parse_source('jsx_component.jsx').parse }
  it 'has expressions as contents' do
    expect(subject.contents).to be_a(Expressions)
  end

  it 'has just one assignment' do
    expect(subject.contents.sub_units.count).to eq(1)
  end
end