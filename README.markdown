#AttributeEnums

AttributeEnums is a model attribute enums plugin for Rails3.

* https://github.com/vkill/attribute_enums

##Supported versions

* Ruby 1.9

* Rails 3


##Installation

In your app's `Gemfile`, add:

    gem "attribute_enums"

or

    gem "attribute_enums", require: "attribute_enums/active_record"
    #app/models/xxx.rb
    include ::AttributeEnums::ActiveRecord


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
      attribute_enums :gender, in: [:female, :male], default: :male, scopeds: true, ask_methods: true, i18n: true, validate: true
      attribute_enums :enable, boolean: true, default: true, scopeds: :disable, i18n: {t_prefix: :person_}
    end

    # in config/locales/enums_en.yml
    en:
      enums:
        gender:
          female: Girl
          male: Boy
        enable:
          "true": "Enable"
          "false": "Disable"
        person_gender:
          female: Girl
          male: Boy
        person_enable:
          "true": "Enable"
          "false": "Disable"

##Options

###in or boolean

if use 'boolean', auto ignore 'in'.

this option generate get_attr_values and attr_text methods

    #active_record
    User.get_gender_values
    User.get_enable_values
    user = User.new(gender: :male, enable: true)
    user.gender_text
    user.enable_text

you can use get_attr_values on rails `select` helper and more.

###i18n and use example

default `false`

set `true`, i18n is valid get_attr_values and attr_text methods.

    #active_record
    User.get_gender_values  #=> [["Girl", "female"], ["Boy", "male"]]
    User.get_enable_values  #=> [["Enable", true], ["Disable", false]]
    user = User.new(gender: :male, enable: true)
    user.gender_text        #=> "Boy"
    user.enable_text        #=> "Enable"

###scopes and use example

default `false`

    #active_record
    User.male         #=> User.where(gender: :male)
    User.female       #=> User.where(gender: :female)
    User.enable       #=> User.where(enable: true)
    User.disable      #=> User.where(enable: false)

###validate

default `false`, it only support `in` option.

if you want support attribute value is nil, you can use `validate: {allow_nil: true}`

###ask_methods and use example

default `false`, it only support `in` option.

    #active_record
    user = User.new(gender: :male, enable: true)
    user.male?    #=> true
    user.female?  #=> false

###default

if your defined `default`, it set attribute `default` value before validate.

    #active_record
    user = User.new
    user.valid?
    user.gender #=> :male

Note: if your migration defined field default, this is invalidation.


##Copyright

Copyright (c) 2011-2013 vkill.net .

