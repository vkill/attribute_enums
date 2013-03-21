require 'attribute_enums/active_record'

module AttributeEnums
  class Railtie < ::Rails::Railtie
    initializer 'attribute_enums' do |app|
      ActiveSupport.on_load :active_record do
        include ::AttributeEnums::ActiveRecord
      end
    end
  end
end

