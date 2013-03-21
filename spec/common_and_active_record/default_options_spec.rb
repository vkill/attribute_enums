require 'spec_helper'

describe ":default options" do
  
  describe "string attribute" do

    let(:model_klass) do
      _person = Person.dup
      _person.instance_eval do
        include AttributeEnums::ActiveRecord
        attribute_enums :gender, in: [:male, :female], default: :male
      end
      _person
    end

    subject { model_klass.new }

    it do
      subject.gender = nil
      subject.valid?
      subject.gender.should == :male
    end

    it do
      subject.gender = :female
      subject.valid?
      subject.gender.should == :female
    end

    it do
      my_person = Person.dup
      lambda do
        my_person.instance_eval do
          include AttributeEnums::ActiveRecord
          attribute_enums :gender, in: [:male, :female], default: :unknow
        end
      end.should raise_error(Exception, /default value not match/)
    end

    it do
      my_person = Person.dup
      lambda do
        my_person.instance_eval do
          include AttributeEnums::ActiveRecord
          attribute_enums :gender, in: [:male, :female], default: 'male'
        end
      end.should_not raise_error(Exception, /default value not match/)
    end
  end

  describe "boolean attribute" do

    let(:model_klass) do
      _person = Person.dup
      _person.instance_eval do
        include AttributeEnums::ActiveRecord
        attribute_enums :enable, boolean: true, default: true
      end
      _person
    end

    subject { model_klass.new }

    it do
      subject.enable = nil
      subject.valid?
      subject.enable.should == true
    end

    it do
      subject.enable = false
      subject.valid?
      subject.enable.should == false
    end
  end
  
end