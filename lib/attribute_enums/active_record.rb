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
        set_defaule_method_name = "set_defaule_#{@_ae_attribute_name}"
        before_validation set_defaule_method_name, if: :"read_attribute(:#{@_ae_attribute_name}).nil?"
        if @_ae_boolean
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{set_defaule_method_name}
              write_attribute(:#{@_ae_attribute_name}, #{@_ae_default})
            end
          RUBY
        else
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{set_defaule_method_name}
              write_attribute(:#{@_ae_attribute_name}, :#{@_ae_default})
            end
          RUBY
        end
      end

      def _attribute_enums_set_string_methods
        @_ae_in.each do |_in|
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{_attribute_enums_methods_string_attribute_method_name(_in)}
              read_attribute(:#{@_ae_attribute_name}).to_s == '#{_in}'
            end
          RUBY
        end
      end

      def _attribute_enums_set_string_scopeds
        @_ae_in.each do |_in|
          scope _attribute_enums_scopeds_string_attribute_method_name(_in), ->{ where(@_ae_attribute_name => _in) }
        end
      end
      
      def _attribute_enums_set_boolean_scopeds
        scope @_ae_attribute_name, ->{ where(@_ae_attribute_name => true) }
        if @_ae_scopeds.is_a?(Symbol)
          scope @_ae_scopeds, ->{ where(@_ae_attribute_name => false) }
        end
      end

      def _attribute_name_set_string_validate
        unless @_ae_validate.is_a?(Hash) and !@_ae_validate[:allow_nil].nil?
          validates @_ae_attribute_name, presence: true
        end

        validates @_ae_attribute_name, inclusion: {in: @_ae_inclusion}, unless: :"read_attribute(:#{@_ae_attribute_name}).nil?"
      end

      def _attribute_name_set_boolean_text_method
        if @_ae_i18n and defined?(::I18n)
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{_attribute_enums_i18n_text_method_name}
              return '' if read_attribute(:#{@_ae_attribute_name}).nil?
              I18n.translate('enums.%s%s.%s' % [self.class.send(:_attribute_enums_i18n_t_prefix), :#{@_ae_attribute_name}, read_attribute(:#{@_ae_attribute_name})])
            end
          RUBY
        else
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{_attribute_enums_i18n_text_method_name}
              return '' if read_attribute(:#{@_ae_attribute_name}).nil?
              read_attribute(:#{@_ae_attribute_name}) ? 'Yes' : 'No'
            end
          RUBY
        end
      end

      def _attribute_name_set_string_text_method
        if @_ae_i18n and defined?(::I18n)
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{_attribute_enums_i18n_text_method_name}
              return '' if read_attribute(:#{@_ae_attribute_name}).nil?
              I18n.translate('enums.%s%s.%s' % [self.class.send(:_attribute_enums_i18n_t_prefix), :#{@_ae_attribute_name}, read_attribute(:#{@_ae_attribute_name})])
            end
          RUBY
        else
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{_attribute_enums_i18n_text_method_name}
              return '' if read_attribute(:#{@_ae_attribute_name}).nil?
              read_attribute(:#{@_ae_attribute_name}).to_s
            end
          RUBY
        end
      end

    end
  end

end

