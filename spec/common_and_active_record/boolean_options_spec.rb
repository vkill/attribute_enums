require 'spec_helper'

describe ":boolean options" do

  let(:model_klass) do
    _person = Person.dup
    _person.instance_eval do
      include AttributeEnums::ActiveRecord
      attribute_enums :enable, boolean: true
    end
    _person
  end

  subject { model_klass.new }

  it do
    model_klass.should respond_to(:get_enable_values)
  end

  it do
    model_klass.get_enable_values.should == [['Yes', true], ['No', false]]
  end

  it do
    subject.should respond_to(:enable_text)
  end

  it do
    subject.enable = nil
    subject.enable_text.should == ''
  end

  it do
    subject.enable = true
    subject.enable_text.should == 'Yes'
  end

  it do
    subject.enable = false
    subject.enable_text.should == 'No'
  end

end