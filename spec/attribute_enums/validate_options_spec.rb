require 'spec_helper'

describe ":validate options" do

  describe "string attribute" do
    let(:model_klass) do
      _person = Person.dup
      _person.instance_eval do
        include AttributeEnums::ActiveRecord
        attribute_enums :gender, in: [:male, :female], validate: true
      end
      _person.stub_chain('model_name.human').and_return(:Person)
      _person.stub_chain('model_name.i18n_key').and_return(:person)
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
        _person.stub_chain('model_name.human').and_return(:Person)
        _person.stub_chain('model_name.i18n_key').and_return(:person)
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
    # this option is invalid boolean attribute.
  end

end