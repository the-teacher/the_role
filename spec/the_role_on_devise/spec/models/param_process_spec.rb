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

  it "should work with Controller Name" do
    ctrl = PagesController.new
    ctrl.controller_path

    TheRoleParam.process(ctrl.controller_path).should eq 'pages'
  end

  it "should work with Nested Controller Name" do
    class Admin::PagesController < ApplicationController; end
    ctrl = Admin::PagesController.new
    ctrl.controller_path

    TheRoleParam.process(ctrl.controller_path).should eq 'admin_pages'
  end
end