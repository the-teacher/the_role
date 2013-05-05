require 'spec_helper'

describe Hash do
  context "METHODS" do
    it "underscorify_keys" do
      Hash.new.respond_to?(:underscorify_keys).should eq true 
    end

    it "underscorify_keys!" do
      Hash.new.respond_to?(:underscorify_keys!).should eq true 
    end

    it "deep_reset" do
      Hash.new.respond_to?(:deep_reset).should eq true 
    end
    
    it "deep_reset!" do
      Hash.new.respond_to?(:deep_reset!).should eq true 
    end

    it "deep_merge" do
      Hash.new.respond_to?(:deep_merge).should eq true
    end
    
    it "deep_merge!" do
      Hash.new.respond_to?(:deep_merge!).should eq true
    end
  end

  context "deep HASH.underscorify_keys" do
    it "UNDERSCORIFY hash keys" do
      hash = {
        'a b' => 1,
        "x y" => {
          :hello => 1,
          :'hello-world' => 1,
          'good MorninG mom!' => 1
        }
      }
      result = {
        'a_b' => 1,
        'x_y' => {
          'hello' => 1,
          'hello_world' => 1,
          'good_morning_mom' => 1
        }
      }
      hash.underscorify_keys.should eq result
      hash.should_not               eq result
    end

    it "UNDERSCORIFY! hash keys" do
      hash = {
        'a b' => 1,
        "x y" => {
          'hello' => 1
        }
      }
      result = {
        'a_b' => 1,
        'x_y' => {
          'hello' => 1
        }
      }
      hash.underscorify_keys!.should eq result
      hash.should                    eq result
    end    
  end

  context "HASH.deep_reset" do
    before(:each) do
      @hash = {
        :pages => {
          :index   => true,
          :show    => true,
          :new     => false,
          :edit    => false,
          :update  => false,
          :destroy => false
        },
        :articles => {
          :index   => true,
          :show    => true
        }
      }
    end

    it "DEEP RESET hash values to nil" do
      result = {
        :pages => {
          :index   => nil,
          :show    => nil,
          :new     => nil,
          :edit    => nil,
          :update  => nil,
          :destroy => nil
        },
        :articles => {
          :index   => nil,
          :show    => nil
        }
      }
      hash = @hash.deep_reset
      hash.should eq result
    end

    it "DEEP RESET hash values to nil :test" do
      result = {
        :pages => {
          :index   => :test,
          :show    => :test,
          :new     => :test,
          :edit    => :test,
          :update  => :test,
          :destroy => :test
        },
        :articles => {
          :index   => :test,
          :show    => :test
        }
      }
      hash = @hash.deep_reset(:test)
      hash.should eq result
    end

    it "DEEP RESET! hash values to nil" do
      result = {
        :pages => {
          :index   => :test,
          :show    => :test,
          :new     => :test,
          :edit    => :test,
          :update  => :test,
          :destroy => :test
        },
        :articles => {
          :index   => :test,
          :show    => :test
        }
      }
      hash = @hash.deep_reset(:test)
      hash.should      eq  result
      @hash.should_not eq result
    end
  end

  context "DEEP RESET! with different keys types" do
    it "work fine" do
      hash = {
        'pages' => {
          :index => true,
          'edit' => true
        }
      }
      result = {
        'pages' => {
          :index => nil,
          'edit' => nil
        }
      }
      hash.deep_reset!(nil).should eq result
    end
  end

  context "DEEP MERGE" do
    it " => hashes" do
      first_hash = {
        'pages' => {
          'index' => false,
          'edit'  => false
        }
      }

      second_hash = {
        'pages' => {
          'index'   => true,
          'edit'    => false,
          'destroy' => true
        }
      }

      result = {
        'pages' => {
          'index'   => true,
          'edit'    => false,
          'destroy' => true
        }
      }

      first_hash.deep_merge!(second_hash).should eq result
    end

    it "should merge 2 hash (1st 3-lavels, 2nd - 2 levels => 2 level)" do
      first_hash = {
        'pages' => {
          'index' => false,
          'edit'  => {
            'one' => 1,
            'two' => 2
          }
        }
      }

      second_hash = {
        'pages' => {
          'index'   => true,
          'edit'    => false,
          'destroy' => true
        }
      }

      result = {
        'pages' => {
          'index'   => true,
          'edit'    => false,
          'destroy' => true
        }
      }

      first_hash.deep_merge!(second_hash).should eq result
    end
  end

  context "DEEP MERGE!" do
    before(:each) do
      @incoming_hash = {
        'pages' => {
          'edit'    => true,
          'manage'  => true,
          'destroy' => true
        }
      }
      @base_hash = {
        'pages' => {
          'index'   => true,
          'edit'    => false,
          'destroy' => false,
          'banners' => false
        }
      }
    end

    it 'should reset base hash to false' do
      result = {
        'pages' => {
          'index'   => nil,
          'edit'    => nil,
          'destroy' => nil,
          'banners' => nil
        }
      }
      @base_hash.deep_reset!
      @base_hash.should == result
    end

    it 'should merge 2 hashes' do
      result = {
        'pages' => {
          'index'   => false,
          'edit'    => true,
          'manage'  => true,
          'destroy' => true,
          'banners' => false
        }
      }

      @base_hash.deep_reset!(false)
      @base_hash.deep_merge! @incoming_hash
      @base_hash.should == result
    end
  end
end