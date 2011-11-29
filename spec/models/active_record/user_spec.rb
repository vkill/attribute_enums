require 'spec_helper'

describe User do
  context "test :in" do
    before {
      User.attribute_enums :gender, :in => [:female, :male]
    }
    it { User.male.new.gender.should == "male" }
    it { User.female.new.gender.should == "female" }
    it { User.get_gender_values.should == [["female", "Girl"], ["male", "Boy"]] }
    it { User.gender_values.should == {"female"=>"Girl", "male"=>"Boy"} }

    user = User.create(:gender => :male)
    it { user.gender_text.should == "Boy" }
    it { user.male?.should be_true }
    it { user.female?.should be_false }
  end

  context "test :booleans" do
    before {
      User.attribute_enums :enable, :booleans => true
    }
    it { User.enable.new.enable.should == true }
    it { User.not_enable.new.enable.should == false }
    it { User.get_enable_values.should == [[true, "Yes"], [false, "No"]] }
    it { User.enable_values.should == {true=>"Yes", false=>"No"} }

    user = User.create(:enable => true)
    it { user.enable_text.should == "Yes" }
    it { user.enable.should be_true }
  end
end

