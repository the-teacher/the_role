require 'spec_helper'

describe Role do
  context "test base fields" do
    before(:each) do
      @role = FactoryGirl.create :role
    end

    after(:each) do
      Role.destroy_all
    end

    # args: :ruby => 1.8 , :ruby => 1.9
    #it "should has base fields (ruby 1.8)" do
    #  @role.name.should          == 'empty'
    #  @role.title.should         == 'empty'
    #  @role.description.should   == 'empty'
    #  @role.the_role.should      == "{}"
    #  @role.the_role.should      == {}.to_json
    #  @role.the_role.should      == Hash.new.to_json
    #end

    it "should has base fields (ruby 1.8 and 1.9)" do
      @role.name.should          == 'empty'
      @role.title.should         == 'empty'
      @role.description.should   == 'empty'
      @role.the_role.should      == "{}"
      @role.the_role.should      == {}.to_json
      @role.the_role.should      == Hash.new.to_json
    end
  end

  context "Role validation errors" do
    before(:all) do
      @wrong_role = Role.new()
    end

    it "has errors" do
      @wrong_role.save.should be false
    end

    it "should has 3 errors" do
      @wrong_role.errors.count.should be 3
    end
  end

  context "Role" do
    before(:all) do
      @role = FactoryGirl.create(:custom_role)
    end

    after(:all) do
      Role.destroy_all
    end

    it "1 role should be exists" do
      Role.count.should be 1
    end

    it "it's should be *custom_role*" do
      Role.first.name.should  == 'custom_role'
    end

    it "role should has string of rules" do
      Role.first.the_role.should be_an_instance_of String
    end

    it "role should has *to_hash* method" do
      Role.first.to_hash.should be_an_instance_of Hash
    end

    it "role should has *to_json* method" do
      Role.first.to_json.should be_an_instance_of String
    end

    it "role should has *update_role!* method" do
      Role.first.respond_to?('update_role').should be_true
    end

    it "role should has *rule_on*, *rule_off* methods" do
      Role.first.respond_to?(:rule_on).should be_true
      Role.first.respond_to?(:rule_off).should be_true
    end

    it "role should has 2 *controller* levels " do
      Role.first.to_hash.size.should be 2
    end

    it "role should has *pages* section" do
      Role.first.to_hash['pages'].should be_an_instance_of Hash
    end

    it "role should has 6 items at *pages* section" do
      Role.first.to_hash['pages'].size.should be 6
    end

    it "role should has *articles* section" do
      Role.first.to_hash['articles'].should be_an_instance_of Hash
    end

    it "role should has 2 items at *articles* section" do
      Role.first.to_hash['articles'].size.should be 2
    end
    
    it "role should has *pages/index* as true" do
      Role.first.to_hash['pages']['index'].should be_true
    end
    
    it "role should has *pages/new* as false" do
      Role.first.to_hash['pages']['new'].should be_false
    end

    it "role should has *articles/index* as true" do
      Role.first.to_hash['articles']['index'].should be_true
    end

    it "role should has *articles/show* as true" do
      Role.first.to_hash['articles']['show'].should be_true
    end

    it "role should not has *articles/destroy*" do
      Role.first.to_hash['articles']['destroy'].should be_nil
    end

    it "*custom_role* role.to_hash should be original hash" do
      result = Role.first.to_hash

      result['pages']['index'].should   eq true
      result['pages']['show'].should    eq true
      result['pages']['new'].should     eq false
      result['pages']['edit'].should    eq false
      result['pages']['update'].should  eq false
      result['pages']['destroy'].should eq false
      result['pages']['some'].should    be_nil

      result['articles']['index'].should eq true
      result['articles']['show'].should  eq true
      result['articles']['some'].should  be_nil
    end

    it "*custom_role* should be correctly *deep_reset!*" do
      result = Role.first.to_hash.deep_reset!(false)

      result['pages']['index'].should   eq false
      result['pages']['show'].should    eq false
      result['pages']['new'].should     eq false
      result['pages']['edit'].should    eq false
      result['pages']['update'].should  eq false
      result['pages']['destroy'].should eq false
      result['pages']['some'].should    be_nil

      result['articles']['index'].should eq false
      result['articles']['show'].should  eq false
      result['articles']['some'].should  be_nil
    end

    it "merge role with incoming hash" do
      incoming_hash = {
        'pages' => {
          'new'   => true,
          'edit'  => true
        },
        'articles' => {
          'index' => true
        }
      }
      result = {
        'pages' => {
          'index'   => false,
          'show'    => false,
          'new'     => true,
          'edit'    => true,
          'update'  => false,
          'destroy' => false
        },
        'articles' => {
          'index'   => true,
          'show'    => false
        }
      }
      res = @role.to_hash
      res.deep_reset!(false).deep_merge! incoming_hash
      res.should eq result
    end
  end

  context "Role Update special test" do
    before(:all) do
      @role = FactoryGirl.create('pages_min')
    end

    after(:all) do
      Role.destroy_all
    end

    it "min hashes should be equal" do
      pages_min = {
        'pages' => {
          'index' => false
        }
      }
      @role.to_hash.should == pages_min
    end

    it "min hashes should be updated" do
      incoming_hash = {
        'pages' => {
          'index' => true
        }
      }
      @role.update_role incoming_hash
      @role.to_hash.should == incoming_hash
    end
  end

  context "CRUD testing" do
    before(:all) do
      @role = FactoryGirl.create(:custom_role)
    end

    after(:all) do
      Role.destroy_all
    end

    it "we are should has *custom_role* " do
      result = Role.first.to_hash

      result['pages']['index'].should   eq true
      result['pages']['show'].should    eq true
      result['pages']['new'].should     eq false
      result['pages']['edit'].should    eq false
      result['pages']['update'].should  eq false
      result['pages']['destroy'].should eq false
      result['pages']['some'].should    be_nil

      result['articles']['index'].should eq true
      result['articles']['show'].should  eq true
      result['articles']['some'].should  be_nil
    end

    context "SECTION" do
      it "Create section *blogs* [first time]" do
        role   = Role.first
        role.create_section('blogs').should be_true
        result = Role.first.to_hash

        result['blogs'].should be_an_instance_of Hash
        result['blogs'].should be_empty
      end

      it "Create section *blogs* [second time] - should return false" do
        role = Role.first
        role.create_section('blogs').should be_true
        role.create_section(:blogs).should  be_true
        Role.first.to_hash['blogs'].should be_an_instance_of Hash
      end

      it "Section *blogs* should be nil at this test (hmmm...)" do
        Role.first.to_hash['blogs'].should be_nil
      end

      it "Delete section *blogs*" do
        Role.first.create_section('blogs').should be_true
        Role.first.to_hash['blogs'].should be_an_instance_of Hash
        Role.first.delete_section('blogs').should be_true
        Role.first.delete_section('blogs').should be_false
        Role.first.to_hash['blogs'].should be_nil
      end
    end

    context "RULE" do
      context "CREATE" do
        context "Blank names" do
          it "Empty name" do
            role = Role.first
            role.create_rule('blogs', '').should be_false
          end

          it "Blank name" do
            role = Role.first
            role.create_rule('blogs', '   ').should be_false
          end

          it "Nil name" do
            role = Role.first
            role.create_rule('blogs', nil).should be_false
          end          
        end
      end

      it "Create rule *blogs/index* [first time]" do
        role   = Role.first
        role.create_rule('blogs', 'index').should be_true
        result = Role.first.to_hash

        result['blogs'].should         be_an_instance_of Hash
        result['blogs'].should_not     be_empty
        result['blogs']['index'].should be_false
      end

      it "Second call of create method should gives TRUE" do
        role   = Role.first
        role.create_rule('blogs', 'index').should be_true
        role.create_rule(:blogs, 'index').should   be_true
      end

      it "Create rule *blogs/index* [second time] - should return false" do
        role   = Role.first
        role.create_rule('blogs', 'index').should be_true
        role.create_rule('blogs', 'index').should be_true

        result = Role.first.to_hash
        result['blogs'].should         be_an_instance_of Hash
        result['blogs'].should_not     be_empty
        result['blogs']['index'].should be_false
      end

      it "Section *blogs* should be nil at this test (hmmm...)" do
        Role.first.to_hash['blogs'].should be_nil
      end
      
      it "Delete rule *blogs/index*" do
        role = Role.first
        role.create_rule('blogs', 'index').should be_true
        Role.first.to_hash['blogs']['index'].should be_false
        role.delete_rule('blogs', 'index').should be_true
      end
    end

    context "ROLE UPDATE" do
      it "*rule_on* is false if section/rule not exists" do
        role = Role.first
        role.rule_on('blogs', 'index').should be_false
      end

      it "*rule_on* is true  if section/rule is exists" do
        role = Role.first
        role.create_rule('blogs', 'index').should be_true
        role.rule_on('blogs', 'index').should     be_true
        role.rule_on('blogs', 'index').should     be_true
      end

      it "*rule_on* is true  if section/rule is exists" do
        role = Role.first
        role.create_rule('blogs', 'index').should be_true
        role.rule_on('blogs', 'index').should     be_true
        role.to_hash['blogs']['index'].should be_true
      end

      it "*rule_off* is false if section/rule not exists" do
        role = Role.first
        role.rule_off('blogs', 'index').should be_false
      end

      it "*rule_off* is true  if section/rule is exists" do
        role = Role.first
        role.create_rule('blogs', 'index').should be_true
        role.rule_on('blogs', 'index').should     be_true
        role.rule_off('blogs', 'index').should    be_true
      end

      it "*rule_off* is true if section/rule is exists" do
        role = Role.first
        role.create_rule('blogs', 'index').should be_true
        role.rule_off('blogs', 'index').should    be_true
        role.to_hash['blogs']['index'].should       be_false
      end

      it "*rule_on* + *rule_off* complex test" do
        role = Role.first

        role.rule_on('blogs', 'index').should     be_false
        role.rule_off('blogs', 'index').should    be_false
  
        role.create_rule('blogs', 'index').should be_true
        role.to_hash['blogs']['index'].should       be_false

        3.times do 
          role.rule_on('blogs', 'index').should   be_true
          role.to_hash['blogs']['index'].should     be_true

          role.rule_off('blogs', 'index').should  be_true
          role.to_hash['blogs']['index'].should     be_false          
        end

        role.delete_rule('blogs', 'index').should be_true
        role.to_hash['blogs']['index'].should       be_nil

        role.rule_on('blogs', 'index').should     be_false
        role.rule_off('blogs', 'index').should    be_false

        role.delete_section('blogs').should       be_true
        role.to_hash['blogs'].should               be_nil
      end

      it "we are should has *custom_role* " do
        result = Role.first.to_hash

        result['pages']['index'].should   eq true
        result['pages']['show'].should    eq true
        result['pages']['new'].should     eq false
        result['pages']['edit'].should    eq false
        result['pages']['update'].should  eq false
        result['pages']['destroy'].should eq false
        result['pages']['some'].should    be_nil

        result['articles']['index'].should eq true
        result['articles']['show'].should  eq true
        result['articles']['some'].should  be_nil
      end

      it "*role_update* method :sym keys" do
        incoming_hash = {
          'pages' => {
            :new   => true,
            'edit'  => true
          },
          'articles' => {
            :destroy => true
          }
        }

        Role.first.update_role(incoming_hash).should be_true

        result = {
          'pages' => {
            'index'   => false,
            'show'    => false,
            'new'     => true,
            'edit'    => true,
            'update'  => false,
            'destroy' => false
          },
          'articles' => {
            'index'   => false,
            'show'    => false,
            'destroy' => true
          }
        }
        Role.first.to_hash.should eq result
      end

      it "*role_update* method has nil as param" do
        Role.first.update_role(nil).should be_true
      end

      it "*role_update* method 'word' keys" do
        incoming_hash = {
          'pages' => {
            'new'   => true,
            'edit'  => true
          },
          'articles' => {
            'destroy' => true
          }
        }
        
        Role.first.update_role(incoming_hash).should be_true

        result = {
          'pages' => {
            'index'   => false,
            'show'    => false,
            'new'     => true,
            'edit'    => true,
            'update'  => false,
            'destroy' => false
          },
          'articles' => {
            'index'   => false,
            'show'    => false,
            'destroy' => true
          }
        }
        Role.first.to_hash.should eq result
      end

      describe "Second call of create methods should gives TRUE" do
        it "*create_section* 'blogs'" do
          Role.first.to_hash['blogs'].should be_nil
          Role.first.create_section('blogs').should be_true
          Role.first.create_section('blogs').should be_true
        end

        it "*create_section* :blogs" do
          Role.first.to_hash['blogs'].should be_nil
          Role.first.create_section(:blogs).should be_true
          Role.first.create_section(:blogs).should be_true
        end
      end

      it "*delete_section* 'blogs'" do
        Role.first.to_hash['blogs'].should be_nil
        Role.first.create_section(:blogs).should  be_true
        Role.first.delete_section('blogs').should be_true
      end

      it "*delete_section* :blogs" do
        #Role.first.to_hash['blogs'].should be_nil
        Role.first.create_section('blogs').should be_true
        Role.first.delete_section(:blogs).should  be_true
      end

      it "*create_section* with EMPTY param" do
        Role.first.create_section().should be_false
      end

      it "*delete_section* with EMPTY param" do
        Role.first.delete_section().should be_false
      end

    end
  end

  context "Role Api testing" do
    before(:all) do
      @user_role      = FactoryGirl.create(:user_role)
      @admin_role     = FactoryGirl.create(:admin_role)
      @moderator_role = FactoryGirl.create('pages_moderator_role')
    end

    after(:all) do
      Role.destroy_all
    end

    it "Role.count should be 3" do
      Role.count.should be 3
    end

    # DE-FACTO - BASE API AND BEHAVIOR OF ROLE SYSTEM
    describe "User role" do
      it "user HAS?('pages', 'index') should be true" do
        @user_role.has?('pages', 'index').should be_true
        @user_role.has?('pages', 'index').should   be_true
      end

      it "user HAS?('pages', 'blabla') should be false" do
        @user_role.has?('pages', 'blabla').should be_false
        @user_role.has?('pages', 'blabla').should   be_false
      end

      it "user HAS?('system', 'administrator') should be false" do
        @user_role.has?('system', 'administrator').should be_false
        @user_role.has?('system', 'administrator').should   be_false
      end

      it "user HAS?('moderator', 'pages') should be false" do
        @user_role.has?('moderator', 'pages').should be_false
        @user_role.has?('moderator', 'pages').should   be_false
      end

      it "user MODERATOR?('pages') should be false" do
        @user_role.moderator?('pages').should be_false
        @user_role.moderator?('pages').should  be_false
      end

      it "user ADMIN? should be false" do
        @user_role.admin?.should be_false
      end

    end

    describe "Moderator role" do
      it "moderator HAS?('pages', 'index') should be true" do
        @moderator_role.has?('pages', 'index').should be_true
        @moderator_role.has?('pages', 'index').should   be_true
      end

      it "moderator HAS?('pages', 'blabla') should be true" do
        @moderator_role.has?('pages', 'blabla').should be_true
        @moderator_role.has?('pages', 'blabla').should   be_true
      end

      it "moderator HAS?('system', 'administrator') should be false" do
        @moderator_role.has?('system', 'administrator').should be_false
        @moderator_role.has?('system', 'administrator').should   be_false
      end

      it "moderator HAS?('moderator', 'pages') should be true" do
        @moderator_role.has?('moderator', 'pages').should be_true
        @moderator_role.has?('moderator', 'pages').should   be_true
      end

      it "moderator MODERATOR?('pages') should be true" do
        @moderator_role.moderator?('pages').should be_true
        @moderator_role.moderator?('pages').should  be_true
      end

      it "moderator ADMIN? should be false" do
        @moderator_role.admin?.should be_false
      end

    end

    describe "Admin role" do
      it "admin HAS?('pages', 'index') should be true" do
        @admin_role.has?('pages', 'index').should be_true
        @admin_role.has?('pages', 'index').should   be_true
      end

      it "admin HAS?('pages', 'blabla') should be true" do
        @admin_role.has?('pages', 'blabla').should be_true
        @admin_role.has?('pages', 'blabla').should   be_true
      end

      it "admin HAS?('system', 'administrator') should be true" do
        @admin_role.has?('system', 'administrator').should be_true
        @admin_role.has?('system', 'administrator').should   be_true
      end

      it "admin HAS?('moderator', 'pages') should be true" do
        @admin_role.has?('moderator', 'pages').should be_true
        @admin_role.has?('moderator', 'pages').should   be_true
      end

      it "admin MODERATOR?('pages') should be true" do
        @admin_role.moderator?('pages').should be_true
        @admin_role.moderator?('pages').should  be_true
      end

      it "admin ADMIN? should be true" do
        @admin_role.admin?.should be_true
      end
    end

    describe "working after rule_off" do
      it "should turn off admin rules" do
        @admin_role.rule_off('system', 'administrator').should be_true
        @admin_role.admin?.should be_false
        @admin_role.has?('pages', 'index').should be_false
      end

      it "should turn off moderator rules" do
        @moderator_role.rule_off('moderator', 'pages').should be_true
        @moderator_role.admin?.should be_false
        @moderator_role.moderator?('pages').should be_false
        @moderator_role.has?('pages', 'index').should be_false
      end
    end
  end
end
    