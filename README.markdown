#AttributeEnums

AttributeEnums is a model attribute enums plugin for Rails3. like 'symbolize' gem.

* https://github.com/vkill/attribute_enums

##Supported versions

* Ruby 1.8.7, 1.9.2, 1.9.3

* Rails 3.0.x, 3.1


##Installation

In your app's `Gemfile`, add:

    gem "attribute_enums"

Then run:

    > bundle


##Usage Example

###ActiveRecord

    #db/migrate/xxxxxxxxxxxxxx_create_users.rb
    class CreateUsers < ActiveRecord::Migration
      def change
        create_table :users do |t|
          t.string :gender
          t.boolean :enable

          t.timestamps
        end
      end
    end


    #app/models/user.rb
    class User < ActiveRecord::Basse
      attribute_enums :gender, :in => [:female, :male]
      attribute_enums :enable, :booleans => true
    end


##Options

###booleans

default `false`

if use this, please don't use `in/within`.

###in/within

default `[]`

if use this, please don't use `booleans`.

###i18n

default `true`

    en:
      activerecord: #active_record
        models:
          user: User
        attributes:
          user:
            gender: Gender
            enable: Enable
            enums:
              gender:
                female: Girl
                male: Boy
              enable:
                "true": "Yes"
                "false": "No"

###scopes

default `true`

    #active_record
    User.male         => User.where(:gender => :male)
    User.female       => User.where(:gender => :female)
    User.enable       => User.where(:enable => true)
    User.not_enable   => User.where(:enable => false)

###allow_blank

default `false`

###validate

default `true`

###methods

default `true`

    #active_record
    User.get_gender_values  =>  [["female", "Girl"], ["male", "Boy"]]
    User.gender_values      =>  {"female"=>"Girl", "male"=>"Boy"}
    User.get_enable_values  =>  [[true, "Yes"], [false, "No"]]
    User.enable_values      =>  {true=>"Yes", false=>"No"}
    user = User.create(:gender => :male, :enable => true)
    user.gender_text  =>  "Boy"
    user.enable_text  =>  "Yes"
    user.male?    =>  true
    user.female?  =>  false
    user.enable   =>  true

###default

if your defined `default`, it set attribute `default` value before validate.


##Run test for development

    > guard


##Copyright

Copyright (c) 2011 vkill.net .

