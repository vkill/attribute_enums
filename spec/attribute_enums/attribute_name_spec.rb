require 'spec_helper'

describe "attribute_name options" do

  let(:model_klass) do
    _person = Person.dup
    _person.instance_eval do
      include AttributeEnums::ActiveRecord
    end
    _person
  end

end