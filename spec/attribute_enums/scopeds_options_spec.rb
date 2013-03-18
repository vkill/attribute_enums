require 'spec_helper'

describe ":scopeds options" do

  describe "string attribute" do
    describe "default methods" do
      let(:model_klass) do
        _person = Person.dup
        _person.instance_eval do
          include AttributeEnums
          attribute_enums :gender, in: [:male, :female], scopeds: true
        end
        _person
      end

      subject { model_klass.new }

      it do
        model_klass.should respond_to?(:male)
        model_klass.should respond_to?(:female)
      end
      it do
        model_klass.stub(:where).with(gender: :male).and_return([:mock_person])
        subject.male.should == [:mock_person]
      end
    end
  

    describe "prefix methods" do
      let(:model_klass) do
        _person = Person.dup
        _person.instance_eval do
          include AttributeEnums
          attribute_enums :gender, in: [:male, :female], scopeds: {prefix: 'gender_'}
        end
        _person
      end

      subject { model_klass.new }

      it do
        model_klass.should respond_to?(:gender_male)
      end
      it do
        model_klass.stub(:where).with(gender: :male).and_return([:mock_person])
        subject.gender_male.should == [:mock_person]
      end
    end
  end


  describe "boolean attribute" do
    # this option is invalid boolean attribute.
  end


end