require 'spec_helper'

describe User do
  context "test :in" do
    before {
      User.attribute_enums :gender, :in => [:female, :male]
    }
    it { User.male.new.gender.should == "male" }
    it { User.female.new.gender.should == "female" }
    it { User.get_gender_values.should == [["Girl", "female"], ["Boy", "male"]] }
    it { User.gender_values.should == {"female"=>"Girl", "male"=>"Boy"} }
    
    let(:user) { User.create(:gender => :male) }
    it { user.gender_text.should == "Boy" }
    it { user.male?.should be_true }
    it { user.female?.should be_false }
    
    #:in default == nil
    it { User.create.gender.should be_nil }
  end
  
  context "test :in and :default" do
    before {
      User.attribute_enums :gender, :in => [:female, :male], :default => :female
    }
    let(:user) { User.create() }
    it { user.gender.should_not be_nil }
    it { user.gender.should == "female" }
  end
  

  context "test :booleans" do
    before {
      User.attribute_enums :enable, :booleans => true
    }
    it { User.enable.new.enable.should == true }
    it { User.not_enable.new.enable.should == false }
    it { User.get_enable_values.should == [["Yes", true], ["No", false]] }
    it { User.enable_values.should == {true=>"Yes", false=>"No"} }
    
    let(:user) { User.create(:enable => true) }
    it { user.enable.should be_true }
    it { user.enable_text.should == "Yes" }
    
    #:booleans default == true
    it { User.create.enable.should be_true }
  end
  
  context "test :booleans and :default => false" do
    before {
      User.attribute_enums :enable, :booleans => true, :default => false
    }    
    let(:user) { User.create() }
    it { user.enable.should be_false }
    it { user.enable.should_not be_nil }
  end
  
  context "test :booleans and :default => true" do
    before {
      User.attribute_enums :enable, :booleans => true, :default => true
    }    
    let(:user) { User.create() }
    it { user.enable.should be_true }
    it { user.enable.should_not be_nil }
  end
end

