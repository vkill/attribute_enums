require 'spec_helper'

describe ":scopeds options" do

  describe "string attribute" do
    describe "default methods" do
      let(:model_klass) do
        _person = Person.dup
        _person.instance_eval do
          include AttributeEnums::ActiveRecord
          attribute_enums :gender, in: [:male, :female], scopeds: true
        end
        _person
      end

      it do
        model_klass.should respond_to(:male)
        model_klass.should respond_to(:female)
      end
      it do
        model_klass.stub(:where).with(gender: :male).and_return([:mock_person])
        model_klass.male.should == [:mock_person]
      end
    end
  

    describe "prefix methods" do
      let(:model_klass) do
        _person = Person.dup
        _person.instance_eval do
          include AttributeEnums::ActiveRecord
          attribute_enums :gender, in: [:male, :female], scopeds: {prefix: 'gender_'}
        end
        _person
      end      

      it do
        model_klass.should respond_to(:gender_male)
      end
      it do
        model_klass.stub(:where).with(gender: :male).and_return([:mock_person])
        model_klass.gender_male.should == [:mock_person]
      end
    end
  end


  describe "boolean attribute" do
    describe "only true methods" do
      let(:model_klass) do
        _person = Person.dup
        _person.instance_eval do
          include AttributeEnums::ActiveRecord
          attribute_enums :enable, boolean: true, scopeds: true
        end
        _person
      end

      it do
        model_klass.should respond_to(:enable)
      end
      it do
        model_klass.stub(:where).with(enable: true).and_return([:mock_person])
        model_klass.enable.should == [:mock_person]
      end
    end

    describe "has true and false methods" do
      let(:model_klass) do
        _person = Person.dup
        _person.instance_eval do
          include AttributeEnums::ActiveRecord
          attribute_enums :enable, boolean: true, scopeds: :disable
        end
        _person
      end

      it do
        model_klass.should respond_to(:enable)
      end
      it do
        model_klass.stub(:where).with(enable: true).and_return([:mock_person])
        model_klass.enable.should == [:mock_person]
      end

      it do
        model_klass.should respond_to(:disable)
      end
      it do
        model_klass.stub(:where).with(enable: false).and_return([:mock_person])
        model_klass.disable.should == [:mock_person]
      end
    end
  end


end