require 'spec_helper'

describe ":methods options" do

  describe "string attribute" do
    describe "default methods" do
      let(:model_klass) do
        _person = Person.dup
        _person.instance_eval do
          include AttributeEnums
          attribute_enums :gender, in: [:male, :female], methods: true
        end
        _person
      end

      subject { model_klass.new }

      it do
        subject.should respond_to?(:male?)
        subject.should respond_to?(:female?)
      end
      it do
        subject.gender = :male
        subject.male?.should be_true
        subject.female?.should be_false
      end
    end
  

    describe "prefix methods" do
      let(:model_klass) do
        _person = Person.dup
        _person.instance_eval do
          include AttributeEnums
          attribute_enums :gender, in: [:male, :female], methods: {prefix: 'gender_'}
        end
        _person
      end

      subject { model_klass.new }

      it do
        subject.should respond_to?(:gender_male?)
      end
      it do
        subject.gender = :male
        subject.gender_male?.should be_true
      end
    end
  end


  describe "boolean attribute" do
    # this option is invalid boolean attribute.
  end


end