# encoding: UTF-8
require 'spec_helper'

p 'Y'*30
p FactoryGirl.definition_file_paths
p 'Y'*30

describe User do
  context "no users" do
    it "no body here" do
      User.all.should be_empty
    end
  end
    
  context "one user test" do
    # before(:all) do
    # end

    before(:all) do
      Role.destroy_all
      User.destroy_all
    end

    it "only one" do
      p '================'
      role = FactoryGirl.create(:role)
      u = FactoryGirl.build(:user)
      u.role = role
      p '================>'
      p u.role
      u.save!
      p '================'
      User.count.should be 1
    end

    # it "only one again" do
    #   User.count.should be 1
    # end
  end

  # context 'User has role' do
  #   before(:all) do
  #     @role = FactoryGirl.create(:user_role)
  #     @user = FactoryGirl.create(:user, :role => @role)
  #   end

  #   after(:all) do
  #     User.destroy_all
  #     Role.destroy_all
  #   end

  #   it "one user should be exist" do
  #     User.count.should be 1
  #   end

  #   it "one role should be exist" do
  #     Role.count.should be 1
  #   end

  #   it "user should has role" do
  #     @user.role.should_not be nil
  #   end

  #   it "role should has 1 user of many" do
  #     @role.users.count.should be 1
  #   end

  #   it "should has name" do
  #     @user.role.name.should == 'basic_user'
  #   end

  #   it "should has title" do
  #     @user.role.title.should == 'basic user role'
  #   end

  #   it "should has description" do
  #     @user.role.description.should == 'basic user role set'
  #   end
  # end

  # context 'User working with role' do

  #   before(:each) do
  #     @role = FactoryGirl.create(:custom_role)
  #     @user = FactoryGirl.create(:user, :role => @role)

  #     # base role hash
  #     @custom_role_hash  = {
  #       'pages' => {
  #         'index'   => true,
  #         'show'    => true,
  #         'new'     => false,
  #         'edit'    => false,
  #         'update'  => false,
  #         'destroy' => false
  #       },
  #       'articles' => {
  #         'index'   => true,
  #         'show'    => true
  #       }
  #     }
  #   end

  #   after(:each) do
  #     User.destroy_all
  #     Role.destroy_all
  #   end
    
  #   it "User should has *custom_role*" do
  #     @user.role.should      be_an_instance_of Role
  #     @user.role.name.should == 'custom_role'
  #   end

  #   it "User should has role with *custom_role* hash" do
  #     @user.role.to_hash.should eq @custom_role_hash
  #   end

  #   it "Update User's role and add rule *blogs/index* " do
  #     @user.role.to_hash.should eq @custom_role_hash
  #     @user.role.create_rule('blogs', 'index').should be_true

  #     @user.role.to_hash.should_not eq @custom_role_hash
  #     @user.role.to_hash['blogs']['index'].should be_false
  #   end

  #   it "Add rule *blogs/index* and set to true [*create_rule*, *rule_on*]" do
  #     @user.role.to_hash.should eq @custom_role_hash

  #     @user.role.rule_on('blogs', 'index').should     be_false
  #     @user.role.create_rule('blogs', 'index').should be_true

  #     @user.role.to_hash.should_not eq @custom_role_hash
  #     @user.role.to_hash['blogs']['index'].should be_false

  #     @user.role.rule_on('blogs', 'index').should be_true
  #   end

  #   it "Add rule *blogs/index*, test [*create_rule*, *rule_on*, *delete_rule*]" do
  #     @user.role.to_hash.should eq @custom_role_hash

  #     @user.role.rule_on('blogs', 'index').should     be_false
  #     @user.role.create_rule('blogs', 'index').should be_true

  #     @user.role.to_hash.should_not eq @custom_role_hash
  #     @user.role.to_hash['blogs']['index'].should be_false

  #     @user.role.rule_on('blogs', 'index').should be_true

  #     @user.role.delete_rule('blogs', 'index').should be_true
  #     @user.role.to_hash['blogs']['index'].should       be_nil
  #     @user.role.rule_on('blogs', 'index').should     be_false
  #   end

  #   it "Add rule *blogs/index*, test [*create_rule*, *rule_off*, *delete_rule*]" do
  #     @user.role.to_hash.should eq @custom_role_hash

  #     @user.role.rule_off('blogs', 'index').should     be_false
  #     @user.role.create_rule('blogs', 'index').should  be_true

  #     @user.role.to_hash.should_not eq @custom_role_hash
  #     @user.role.to_hash['blogs']['index'].should be_false

  #     @user.role.rule_on('blogs', 'index').should be_true
  #     @user.role.to_hash['blogs']['index'].should be_true

  #     @user.role.rule_off('blogs', 'index').should be_true
  #     @user.role.to_hash['blogs']['index'].should be_false

  #     @user.role.rule_off('blogs', 'index').should be_true

  #     @user.role.delete_rule('blogs', 'index').should be_true
  #     @user.role.to_hash['blogs']['index'].should       be_nil
  #     @user.role.rule_off('blogs', 'index').should    be_false
  #   end

  # end

  # context 'User correction of wrong params' do
  #   before(:each) do
  #     @role = FactoryGirl.create(:custom_role)
  #     @user = FactoryGirl.create(:user, :role => @role)
  #     # base role hash
  #     @custom_role_hash  = {
  #       :pages => {
  #         'index'   => true,
  #         :show    => true,
  #         :new     => false,
  #         :edit    => false,
  #         :update  => false,
  #         :destroy => false
  #       },
  #       :articles => {
  #         'index'   => true,
  #         :show    => true
  #       }
  #     }
  #   end

  #   after(:each) do
  #     User.destroy_all
  #     Role.destroy_all
  #   end

  #   it "User should has *custom_role*" do
  #     @user.role.should      be_an_instance_of Role
  #     @user.role.name.should == 'custom_role'
  #   end

  #   it "User create section 'some string name' => 'some_string_name'" do
  #     @user.role.create_section 'some string name'
  #     @user.role.to_hash['some_string_name'].should be_an_instance_of Hash
  #   end

  #   it "User create section ' SoMe String NAME  ' => 'some_string_name'" do
  #     @user.role.create_section ' SoMe String NAME  '
  #     @user.role.to_hash['some_string_name'].should be_an_instance_of Hash
  #   end

  #   it "User create section ' xYz Некое UTF-8 подбное имя ё  ou! eee' => :xyz_utf_8_ou_eee" do
  #     @user.role.create_section 'xYz Некое UTF-8 подбное имя ё ou! eee'
  #     @user.role.to_hash['xyz_utf_8_ou_eee'].should be_an_instance_of Hash
  #   end

  #   it "User create rule *blogs/some rule* and set on true" do
  #     @user.role.create_rule 'blogs', 'some rule'
  #     @user.role.to_hash['blogs'].should be_an_instance_of Hash
  #     @user.role.to_hash['blogs']['some_rule'].should be_false

  #     @user.role.rule_on 'blogs', 'some rule'
  #     @user.role.to_hash['blogs']['some_rule'].should be_true
  #   end    
  # end

  # describe 'issue#7::update_attributes not working' do
  #   context 'Attributes' do
  #     before(:all) do
  #       @user = FactoryGirl.create(:user)
  #     end

  #     after(:all) do
  #       User.destroy_all
  #     end

  #     context 'some_protected_field' do
  #       it 'should not be updated' do
  #         new_value = 'BlaBla'
  #         @user.update_attributes!({ :some_protected_field => new_value })
  #         User.first.some_protected_field.should_not == new_value
  #       end
  #     end

  #     context 'Name' do
  #       it 'should be updated' do
  #         another_name = 'John Dow'
  #         @user.update_attributes!({ :name => another_name })
  #         User.first.name.should == another_name
  #       end
  #     end
  #   end
  # end

end