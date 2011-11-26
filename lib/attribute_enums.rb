require "active_support/concern"
require "active_support/core_ext/object"
require "active_support/core_ext/class/attribute_accessors"

require "attribute_enums/version"

if defined?(::Rails)
  require "attribute_enums/railtie"
end

module AttributeEnums
end

