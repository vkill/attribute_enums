#coding: utf-8
require 'spec_helper'

describe ":i18n options" do
  describe "string attribute" do
    describe "default translation namespace" do
      let(:model_klass) do
        _person = Person.dup
        _person.instance_eval do
          include AttributeEnums
          attribute_enums :gender, in: [:male, :female], i18n: true
        end
        _person
      end

      subject { model_klass.new }

      it do
        I18n.stub(:available_locales).and_return([])
        I18n.stub(:locale).and_return(:en)
        model_klass.get_i18n_gender_values.should == {'en' => [['Girl', 'female'], ['Boy', 'male']]}
        model_klass.get_gender_values.should == [['Girl', 'female'], ['Boy', 'male']]
      end

      it do
        I18n.stub(:available_locales).and_return([:en, :'zh-CN'])
        I18n.stub(:locale).and_return(:en)
        model_klass.get_i18n_gender_values.should == {'en' => [['Girl', 'female'], ['Boy', 'male']], 'zh-CN' => [['女', 'female'], ['男', 'male']]}
        model_klass.get_gender_values.should == [['Girl', 'female'], ['Boy', 'male']]
      end

      it do
        I18n.stub(:available_locales).and_return([:en, :'zh-CN'])
        I18n.stub(:locale).and_return(:'zh-TW')
        model_klass.get_gender_values.first[0].should start_with('translation missing:')
      end

      it do
        subject.should respond_to?(:gender_text)
      end

      it do
        I18n.stub(:locale).and_return(:en)
        subject.gender = :male
        subject.gender_text.should == 'Boy'
      end

      it do
        I18n.stub(:locale).and_return(:'zh-CN')
        subject.gender = :male
        subject.gender_text.should == '男'
      end

      it do
        I18n.stub(:locale).and_return(:'zh-TW')
        subject.gender = :male
        subject.gender_text.should start_with('translation missing:')
      end
    end

    describe "prefix translation namespace" do
      let(:model_klass) do
        _person = Person.dup
        _person.instance_eval do
          include AttributeEnums
          attribute_enums :gender, in: [:male, :female], i18n: {t_prefix: :person}
        end
        _person
      end

      subject { model_klass.new }

      it do
        I18n.stub(:available_locales).and_return([])
        I18n.stub(:locale).and_return(:en)
        model_klass.get_gender_values.first[0].should_not start_with('translation missing:')
        model_klass.get_gender_values.should == [['Girl', 'female'], ['Boy', 'male']]
      end

      it do
        I18n.stub(:locale).and_return(:en)
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
          include AttributeEnums
          attribute_enums :enable, boolean: true, i18n: true
        end
        _person
      end

      subject { model_klass.new }

      it do
        I18n.stub(:available_locales).and_return([])
        I18n.stub(:locale).and_return(:en)
        model_klass.get_i18n_enable_values.should == {'en' => [['Yes', true], ['No', false]]}
        model_klass.get_enable_values.should == [['Yes', true], ['No', false]]
      end

      it do
        subject.should respond_to?(:enable_text)
      end

      it do
        I18n.stub(:locale).and_return(:en)
        subject.enable = true
        subject.enable_text.should == 'Yes'
      end
    end
  end


end