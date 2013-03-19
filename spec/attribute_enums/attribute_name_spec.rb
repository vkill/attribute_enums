require 'spec_helper'

describe "attribute_name options" do

  let(:model_klass) do
    _person = Person.dup
    _person.instance_eval do
      include AttributeEnums::ActiveRecord
    end
    _person
  end

  it do
    klass = model_klass.dup
    lambda do
      klass.instance_eval do
        attribute_enums :gender
      end
    end.should_not raise_error(Exception, /method missing/)
  end

  it do
    klass = model_klass.dup
    klass.instance_eval do
      undef_method :gender
    end
    lambda do
      klass.instance_eval do
        attribute_enums :gender
      end
    end.should raise_error(Exception, /method missing/)
  end


  it do
    klass = model_klass.dup
    klass.instance_eval do
      undef_method :gender=
    end
    lambda do
      klass.instance_eval do
        attribute_enums :gender
      end
    end.should raise_error(Exception, /method missing/)
  end

end