require 'spec_helper'

describe ":scopeds options" do

  describe "string attribute" do
    describe "default methods" do
      let(:model_klass) do
        _person = Person.dup
        _person.instance_eval do
          include AttributeEnums::ActiveRecord
          attribute_enums :gender, in: [:male, :female], scopeds: true
        end
        _person
      end

      it do
        model_klass.should respond_to(:male)
        model_klass.should respond_to(:female)
      end
      it do
        gender_a = model_klass.create!(gender: :male)
        gender_b = model_klass.create!(gender: :male)
        gender_c = model_klass.create!(gender: :female)
        model_klass.male.map(&:id).should == [gender_a.id, gender_b.id]
      end
    end
  

    describe "prefix methods" do
      let(:model_klass) do
        _person = Person.dup
        _person.instance_eval do
          include AttributeEnums::ActiveRecord
          attribute_enums :gender, in: [:male, :female], scopeds: {prefix: 'gender_'}
        end
        _person
      end      

      it do
        model_klass.should respond_to(:gender_male)
      end
      it do
        model_klass.delete_all
        gender_a = model_klass.create!(gender: :male)
        gender_b = model_klass.create!(gender: :male)
        gender_c = model_klass.create!(gender: :female)
        model_klass.gender_male.map(&:id).should == [gender_a.id, gender_b.id]
      end
    end
  end


  describe "boolean attribute" do
    describe "only true methods" do
      let(:model_klass) do
        _person = Person.dup
        _person.instance_eval do
          include AttributeEnums::ActiveRecord
          attribute_enums :enable, boolean: true, scopeds: true
        end
        _person
      end

      it do
        model_klass.should respond_to(:enable)
      end
      it do
        model_klass.delete_all
        gender_a = model_klass.create!(enable: true)
        gender_b = model_klass.create!(enable: true)
        gender_c = model_klass.create!(enable: false)
        model_klass.enable.map(&:id).should == [gender_a.id, gender_b.id]
      end
    end

    describe "has true and false methods" do
      let(:model_klass) do
        _person = Person.dup
        _person.instance_eval do
          include AttributeEnums::ActiveRecord
          attribute_enums :enable, boolean: true, scopeds: :disable
        end
        _person
      end

      it do
        model_klass.should respond_to(:enable)
      end
      it do
        model_klass.delete_all
        gender_a = model_klass.create!(enable: true)
        gender_b = model_klass.create!(enable: true)
        gender_c = model_klass.create!(enable: false)
        model_klass.enable.map(&:id).should == [gender_a.id, gender_b.id]
      end

      it do
        model_klass.should respond_to(:disable)
      end
      it do
        model_klass.delete_all
        gender_a = model_klass.create!(enable: true)
        gender_b = model_klass.create!(enable: true)
        gender_c = model_klass.create!(enable: false)
        model_klass.disable.map(&:id).should == [gender_c.id]
      end
    end
  end


end