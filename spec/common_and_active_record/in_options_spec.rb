require 'spec_helper'

describe ":in options" do

  let(:model_klass) do
    _person = Person.dup
    _person.instance_eval do
      include AttributeEnums::ActiveRecord
      attribute_enums :gender, in: [:male, :female]
    end
    _person
  end

  subject { model_klass.new }

  it do
    model_klass.should respond_to(:get_gender_values)
  end

  it do
    model_klass.get_gender_values.should == [['male', 'male'], ['female', 'female']]
  end

  it do
    subject.should respond_to(:gender_text)
  end

  it do
    subject.gender = nil
    subject.gender_text.should == ''
  end

  it do
    subject.gender = :male
    subject.gender_text.should == 'male'
  end

end