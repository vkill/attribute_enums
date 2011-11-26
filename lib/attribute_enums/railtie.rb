require 'attribute_enums/active_record_extension'

module AttributeEnums
  class Railtie < ::Rails::Railtie
    initializer 'attribute_enums' do |app|
      ActiveSupport.on_load :active_record do
        include AttributeEnums::ActiveRecordExtension
      end
    end
  end
end

