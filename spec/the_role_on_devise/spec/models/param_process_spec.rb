# encoding: UTF-8

require 'spec_helper'

describe TheRoleParam do
  it 'module TheRoleParam should be defined' do
    TheRoleParam.class.should be Module
  end

  it 'string process 1' do
    TheRoleParam.process('hello world!').should eq 'hello_world'
  end

  it 'string process 2' do
    TheRoleParam.process(:hello_world!).should eq 'hello_world'
  end

  it 'string process 3' do
    TheRoleParam.process("hello !      world").should eq 'hello_world'
  end

  it 'string process 4' do
    TheRoleParam.process("HELLO  $!= WorlD").should eq 'hello_world'
  end

  it 'string process 5' do
    TheRoleParam.process("HELLO---WorlD").should eq 'hello_world'
  end
end