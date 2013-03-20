module AttributeEnums
end

require "attribute_enums/version"
require "attribute_enums/common"

module AttributeEnums
  module ActiveRecord
    
    def self.included base
      base.extend(ClassMethods)
      base.extend(AttributeEnums::Common)
    end

    module ClassMethods
      
      private

      def _attribute_enums_set_default
        _if = ('%s.nil?' % @_attribute_name).to_sym 
        before_validation(if: _if)do
          write_attribute(@_attribute_name, @_default)
        end
      end

      def _attribute_enums_set_string_methods
        @_in.each do |_in|
          define_method _attribute_enums_methods_string_attribute_method_name(_in) do
            read_attribute(@_attribute_name).to_s == _in.to_s
          end
        end
      end

      def _attribute_enums_set_string_scopeds
        @_in.each do |_in|
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            scope :#{_attribute_enums_scopeds_string_attribute_method_name(_in)}, ->{ where(#{@_attribute_name}: :#{_in}) }
          RUBY
        end
      end
      
      def _attribute_enums_set_boolean_scopeds
        scope @_attribute_name, ->{ where(@_attribute_name => true) }
        if @_scopeds.is_a?(Symbol)
          scope @_scopeds, ->{ where(@_attribute_name => false) }
        end
      end

      def _attribute_name_set_validate
        unless @_validate.is_a?(Hash) and @_validate.delete(:allow_nil)
          validates @_attribute_name, presence: true
        end
        _unless = ('%s.nil?' % @_attribute_name).to_sym
        validates @_attribute_name, inclusion: {in: @_inclusion}, unless: _unless
      end

      def _attribute_name_set_i18n_text
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{_attribute_enums_i18n_text_method_name}
            return nil if read_attribute(:#{@_attribute_name}).nil?
            I18n.translate('enums.%s%s.%s' % [self.class.send(:_attribute_enums_i18n_t_prefix), :#{@_attribute_name}, read_attribute(:#{@_attribute_name})])
          end
        RUBY
      end

    end
  end

end

