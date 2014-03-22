# encoding: UTF-8

require 'spec_helper'

describe "String to slug" do
  it 'string process 1' do
    'hello world!'.to_slug_param(sep: '_').should eq 'hello_world'
  end

  it 'string process 2' do
    :hello_world!.to_slug_param(sep: '_').should eq 'hello_world'
  end

  it 'string process 3' do
    "hello !      world".to_slug_param(sep: '_').should eq 'hello_world'
  end

  it 'string process 4' do
    "HELLO  $!= WorlD".to_slug_param(sep: '_').should eq 'hello_world'
  end

  it 'string process 5' do
    "HELLO---WorlD".to_slug_param(sep: '_').should eq 'hello_world'
  end

  it "should work with Controller Name" do
    ctrl = PagesController.new
    ctrl.controller_path
    ctrl.controller_path.to_slug_param(sep: '_').should eq 'pages'
  end

  it "should work with Nested Controller Name" do
    class Admin::PagesController < ApplicationController; end
    ctrl = Admin::PagesController.new
    ctrl.controller_path

    ctrl.controller_path.to_slug_param(sep: '_').should eq 'admin_pages'
  end
end