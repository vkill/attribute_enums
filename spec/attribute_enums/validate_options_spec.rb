require 'spec_helper'

describe ":validate options" do

  describe "string attribute" do
    let(:model_klass) do
      _person = Person.dup
      _person.instance_eval do
        include AttributeEnums::ActiveRecord
        attribute_enums :gender, in: [:male, :female], validate: true
      end
      _person
    end

    subject { model_klass.new }

    context "valid" do
      it do
        subject.gender = :male
        subject.valid?
        subject.errors[:gender].should == []
      end
      it do
        subject.gender = 'female'
        subject.valid?
        subject.errors[:gender].should == []
      end
    end
    context "invalid" do
      it do
        subject.gender = nil
        subject.valid?
        subject.errors[:gender].should_not == []
      end
      it do
        subject.gender = :unknow
        subject.valid?
        subject.errors[:gender].should_not == []
      end
      it do
        I18n.stub(:translate).and_return('mock_error')
        subject.gender = :unknow
        subject.valid?
        subject.errors[:gender].should == ['mock_error']
      end
    end

    describe "allow_nil" do
      let(:model_klass) do
        _person = Person.dup
        _person.instance_eval do
          include AttributeEnums::ActiveRecord
          attribute_enums :gender, in: [:male, :female], validate: {allow_nil: true}
        end
        _person
      end

      subject { model_klass.new }

      it do
        subject.gender = nil
        subject.valid?
        subject.errors[:gender].should == []
      end
    end
  end


  describe "boolean attribute" do
    let(:model_klass) do
      _person = Person.dup
      _person.instance_eval do
        include AttributeEnums::ActiveRecord
        attribute_enums :enable, boolean: true, validate: true
      end
      _person
    end

    subject { model_klass.new }

    context "valid" do
      it do
        subject.enable = true
        subject.valid?
        subject.errors[:enable].should == []
      end
      it do
        subject.enable = false
        subject.valid?
        subject.errors[:enable].should == []
      end
    end
    context "invalid" do
      it do
        subject.enable = nil
        subject.valid?
        subject.errors[:enable].should_not == []
      end
      it do
        subject.enable = :unknow
        subject.valid?
        subject.errors[:enable].should_not == []
      end
      it do
        I18n.stub(:translate).and_return('mock_error')
        subject.enable = :unknow
        subject.valid?
        subject.errors[:enable].should == ['mock_error']
      end
    end
    describe "allow_nil" do
      let(:model_klass) do
        _person = Person.dup
        _person.instance_eval do
          include AttributeEnums::ActiveRecord
          attribute_enums :enable, boolean: true, validate: true, allow_blank: true
        end
        _person
      end

      subject { model_klass.new }

      it do
        subject.enable = nil
        subject.valid?
        subject.errors[:enable].should == []
      end
    end
  end

end