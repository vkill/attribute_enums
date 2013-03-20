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
        set_defaule_method_name = "set_defaule_#{@_attribute_name}"
        before_validation set_defaule_method_name, if: :"read_attribute(:#{@_attribute_name}).nil?"
        if @_boolean
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{set_defaule_method_name}
              write_attribute(:#{@_attribute_name}, #{@_default})
            end
          RUBY
        else
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{set_defaule_method_name}
              write_attribute(:#{@_attribute_name}, :#{@_default})
            end
          RUBY
        end
      end

      def _attribute_enums_set_string_methods
        @_in.each do |_in|
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{_attribute_enums_methods_string_attribute_method_name(_in)}
              read_attribute(:#{@_attribute_name}).to_s == '#{_in}'
            end
          RUBY
        end
      end

      def _attribute_enums_set_string_scopeds
        @_in.each do |_in|
          scope _attribute_enums_scopeds_string_attribute_method_name(_in), ->{ where(@_attribute_name => _in) }
        end
      end
      
      def _attribute_enums_set_boolean_scopeds
        scope @_attribute_name, ->{ where(@_attribute_name => true) }
        if @_scopeds.is_a?(Symbol)
          scope @_scopeds, ->{ where(@_attribute_name => false) }
        end
      end

      def _attribute_name_set_string_validate
        unless @_validate.is_a?(Hash) and !@_validate[:allow_nil].nil?
          validates @_attribute_name, presence: true
        end

        validates @_attribute_name, inclusion: {in: @_inclusion}, unless: :"read_attribute(:#{@_attribute_name}).nil?"
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

