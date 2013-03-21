#coding: utf-8
require 'spec_helper'

describe ":i18n options" do
  #
  # it i18n xxx_text and get_xxx_values methods result
  #
  describe "string attribute" do
    describe "default translation namespace" do
      let(:model_klass) do
        _person = Person.dup
        _person.instance_eval do
          include AttributeEnums::ActiveRecord
          attribute_enums :gender, in: [:male, :female], i18n: true
        end
        _person
      end

      subject { model_klass.new }

      it do
        model_klass.should respond_to(:get_gender_values)
      end

      it do
        I18n.locale = :en
        model_klass.get_gender_values.should == [['Boy', 'male'], ['Girl', 'female']]
      end

      it do
        I18n.locale = :'zh-TW'
        model_klass.get_gender_values.first[0].should start_with('translation missing:')
      end

      it do
        subject.should respond_to(:gender_text)
      end

      it do
        I18n.locale = :en
        subject.gender = :male
        subject.gender_text.should == 'Boy'
      end

      it do
        I18n.locale = :'zh-CN'
        subject.gender = :male
        subject.gender_text.should == '男'
      end

      it do
        I18n.locale = :'zh-TW'
        subject.gender = :male
        subject.gender_text.should start_with('translation missing:')
      end
    end

    describe "prefix translation namespace" do
      let(:model_klass) do
        _person = Person.dup
        _person.instance_eval do
          include AttributeEnums::ActiveRecord
          attribute_enums :gender, in: [:male, :female], i18n: {t_prefix: :person_}
        end
        _person
      end

      subject { model_klass.new }

      it do
        I18n.locale = :en
        model_klass.get_gender_values.first[0].should_not start_with('translation missing:')
        model_klass.get_gender_values.should == [['Boy', 'male'], ['Girl', 'female']]
      end

      it do
        I18n.locale = :en
        subject.gender = :male
        subject.gender_text.should == 'Boy'
      end
    end
  end




  describe "boolean attribute" do
    describe "default namespace" do
      let(:model_klass) do
        _person = Person.dup
        _person.instance_eval do
          include AttributeEnums::ActiveRecord
          attribute_enums :enable, boolean: true, i18n: true
        end
        _person
      end

      subject { model_klass.new }

      it do
        I18n.locale = :en
        model_klass.get_enable_values.should == [['Enable', true], ['Disable', false]]
      end

      it do
        subject.should respond_to(:enable_text)
      end

      it do
        I18n.locale = :en
        subject.enable = true
        subject.enable_text.should == 'Enable'
      end
    end
  end
end