require 'spec_helper'

describe ":allow_blank options" do

  describe "string attribute" do
    let(:model_klass) do
      _person = Person.dup
      _person.instance_eval do
        include AttributeEnums
        attribute_enums :gender, in: [:male, :female], validate: true, allow_blank: true
      end
      _person
    end

    subject { model_klass.new }

    it do
      subject.gender = nil
      subject.valid?
      subject.errors[:gender].shoud be_nil
    end
  end

  describe "boolean attribute" do
    let(:model_klass) do
      _person = Person.dup
      _person.instance_eval do
        include AttributeEnums
        attribute_enums :enable, boolean: true, validate: true, allow_blank: true
      end
      _person
    end

    subject { model_klass.new }

    it do
      subject.enable = nil
      subject.valid?
      subject.errors[:enable].shoud be_nil
    end
  end

end