require 'spec_helper'

describe Role do
  context "Role *Create* methods" do
    it "New/Create invalid" do
      role = Role.new
      role.save.should be_false
      
      role.should have(1).error_on(:name)
      role.should have(1).error_on(:title)
      role.should have(1).error_on(:description)
    end

    it "New/Create valid, without Role hash" do
      role = Role.new

      role.name        = :user
      role.title       = :user_title
      role.description = :role_description
      
      role.save.should be_true
    end

    it "New/Create valid, without Role hash (2)" do
      Role.new(
        name: :user,
        title: :user_title,
        description: :role_description
      ).save.should be_true
    end

    it "New/Create, without Role hash, default Role hash value" do
      role = FactoryGirl.create :role_without_rules
      role.the_role.should == "{}"
      role.to_hash.should  == {}
    end

    it "New/Create, role methods result types" do
      role = FactoryGirl.create :role_without_rules
      role.the_role.should be_an_instance_of String
      role.to_hash.should  be_an_instance_of Hash
    end
  end

  context "Role *Section/Rule create* methods" do
    before(:each) do
      @role = FactoryGirl.create :role_without_rules
    end

    it "should have empty Role hash" do
      @role.to_hash.should == {}
    end

    it "Create section" do
      @role.create_section(:articles)
      @role.to_hash.should == { "articles" => {} }
    end

    it "Create rule (with section)" do
      @role.create_section(:articles)
      @role.create_rule(:articles, :index)
      @role.to_hash.should == { "articles" => { "index" => false } }
    end

    it "Create rule (without section)" do
      @role.create_rule(:articles, :index)
      @role.to_hash.should == { "articles" => { "index" => false } }
    end
  end

  context "*has?* is aliace of *has_role?*" do
    before(:each) do
      @role = FactoryGirl.create :role_user
    end
    
    it "aliace methods" do
      @role.has?(:pages, :index).should      be_true
      @role.has_role?(:pages, :index).should be_true

      @role.has?(:pages, :secret).should      be_false
      @role.has_role?(:pages, :secret).should be_false
    end
  end

  context "Rule *On/Off* methods" do
    before(:each) do
      @role = FactoryGirl.create :role_user
    end

    it "has access to pages/index" do
      @role.has_role?(:pages, :index).should be_true
    end

    it "set pages/index on false" do
      @role.rule_off(:pages, :index)
      @role.has_role?(:pages, :index).should be_false
    end

    it "has no access to pages/secret" do
      @role.has_role?(:pages, :secret).should be_false
    end

    it "set pages/secret on true" do
      @role.rule_on(:pages, :secret)
      @role.has_role?(:pages, :secret).should be_true
    end
  end

  context "Class Methods" do
    before(:each) do
      @role = FactoryGirl.create :role_user
    end

    it "Role.with_name(:name) method" do
      Role.with_name(:user).should  be_an_instance_of Role
      Role.with_name('user').should be_an_instance_of Role
      
      Role.with_name(:moderator).should  be_nil
      Role.with_name('moderator').should be_nil
    end
  end

  context "*Delete* methods" do
    before(:each) do
      @role = FactoryGirl.create :role_user
    end

    it "*has_section?* method" do
      @role.has_section?(:pages).should    be_true
      @role.has_section?(:articles).should be_false
    end

    it "has pages section" do
      @role.to_hash['pages'].should be_an_instance_of Hash
    end

    it "has pages/index value" do
      @role.to_hash['pages']['index'].should be_true
    end

    it "delete rule pages/index" do
      @role.delete_rule(:pages, :index)
      @role.to_hash['pages']['index'].should be_nil
    end

    it "delete section pages" do
      @role.delete_section(:pages)
      @role.to_hash['pages'].should be_nil
    end
  end

  context "*helper* methods" do
    before(:each) do
      @role = FactoryGirl.create :role_without_rules
    end

    it "to_hash on empty rules set" do
      @role.to_hash.should == {}
    end

    it "to_json on empty rules set" do
      @role.to_json.should == "{}"
    end
  end

  context "Update method" do
    before(:each) do
      @role = FactoryGirl.create :role_user
    end

    it "should has true rules" do
      @role.has?(:pages, :index).should  be_true
      @role.has?(:pages, :edit).should   be_true
      @role.has?(:pages, :update).should be_true
      @role.has?(:pages, :secret).should be_false

      @role.has?(:articles, :index).should be_false
    end

    it "should has true rules" do
      @role.update_role({ articles: { index: true } })

      @role.has?(:pages, :index).should  be_false
      @role.has?(:pages, :edit).should   be_false
      @role.has?(:pages, :update).should be_false
      @role.has?(:pages, :secret).should be_false

      @role.has?(:articles, :index).should be_true
    end

    it "should has any rules 1" do
      @role.has?(:pages, :index).should  be_true
      @role.has?(:pages, :update).should be_true

      @role.any?({ pages: :index  }).should be_true
      @role.any?({ pages: :update }).should be_true
      @role.any?({ pages: :index, pages: :update}).should be_true
    end

    it "should has any rules 2" do
      @role.has?(:pages,    :index).should be_true
      @role.has?(:articles, :index).should be_false

      @role.any?({ pages:    :index }).should be_true
      @role.any?({ articles: :index }).should be_false

      @role.any?({ articles: :index }).should be_false
      @role.any?({ pages: :index, articles: :index}).should be_true
      @role.any?({ pages: :index, pages:    :update}).should be_true
    end

    it "should has any rules 3, easy syntaxis" do
      @role.any?(articles: :index).should be_false
      @role.any?(pages: :index, articles: :index).should be_true
      @role.any?(pages: :index, pages:    :update).should be_true
    end
  end
end