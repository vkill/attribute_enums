require 'spec_helper'

describe "readme user example" do

  before :all do
    User.instance_eval do
      include AttributeEnums::ActiveRecord
      attribute_enums :status, in: [:pending, :accredited], default: :pending, scopeds: true, ask_methods: true, i18n: true, validate: true
      attribute_enums :gender, in: [:female, :male], default: :male, scopeds: true, ask_methods: true, i18n: true, validate: true
      
      attribute_enums :enable, boolean: true, default: true, scopeds: :disable, i18n: {t_prefix: :person_}
      attribute_enums :removed, boolean: true, default: true, scopeds: :existed, i18n: true
    end
  end

  subject { User.new }

=begin
    User.get_gender_values
    User.get_enable_values
    user = User.new(gender: :male, enable: true)
    user.gender_text
    user.enable_text
=end

=begin
    User.get_gender_values  #=> [["Girl", "female"], ["Boy", "male"]]
    User.get_enable_values  #=> [["Enable", true], ["Disable", false]]
    user = User.new(gender: :male, enable: true)
    user.gender_text        #=> "Boy"
    user.enable_text        #=> "Enable"
=end

  it do
    User.get_gender_values.should == [["Girl", "female"], ["Boy", "male"]]
    User.get_enable_values.should == [["Enable", true], ["Disable", false]]
    user = User.new(gender: :male, enable: true)
    user.gender_text.should == "Boy"
    user.enable_text.should == "Enable"
  end

=begin
    User.male         #=> User.where(gender: :male)
    User.female       #=> User.where(gender: :female)
    User.enable       #=> User.where(enable: true)
    User.disable      #=> User.where(enable: false)
=end

  it do
    User.delete_all
    user_a = User.create!(gender: :male)
    user_b = User.create!(gender: :female)
    User.male.map(&:id).should == [user_a.id]
    User.female.map(&:id).should == [user_b.id]

    User.delete_all
    user_c = User.create!(enable: true)
    user_d = User.create!(enable: false)
    User.enable.map(&:id).should == [user_c.id]
    User.disable.map(&:id).should == [user_d.id]
  end

=begin
    user = User.new(gender: :male, enable: true)
    user.male?    #=> true
    user.female?  #=> false
=end

  it do
    user = User.new(gender: :male, enable: true)
    user.male?.should == true
    user.female?.should == false
  end

=begin
    user = User.new
    user.valid?
    user.gender #=> :male
=end

  it do
    user = User.new(gender: :male, enable: true)
    user.valid?
    user.gender.should == :male
  end

end