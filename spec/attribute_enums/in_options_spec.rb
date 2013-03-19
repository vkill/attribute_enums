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

end