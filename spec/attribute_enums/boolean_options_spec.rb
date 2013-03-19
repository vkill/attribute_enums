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


end