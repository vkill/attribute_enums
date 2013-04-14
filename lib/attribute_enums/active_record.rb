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

      def _ae_set_default
        set_defaule_method_name = "set_defaule_#{@_ae_attribute_name}"
        if @_ae_boolean
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{set_defaule_method_name}
              write_attribute(:#{@_ae_attribute_name}, #{@_ae_default}) if read_attribute(:#{@_ae_attribute_name}).nil?
            end
          RUBY
        else
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{set_defaule_method_name}
              write_attribute(:#{@_ae_attribute_name}, :#{@_ae_default}) if read_attribute(:#{@_ae_attribute_name}).nil?
            end
          RUBY
        end
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          before_validation :#{set_defaule_method_name}
        RUBY
      end

      def _ae_set_string_ask_methods
        @_ae_in.each do |_in|
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{_ae_ask_methods_string_attribute_method_name(_in)}
              read_attribute(:#{@_ae_attribute_name}).to_s == '#{_in}'
            end
          RUBY
        end
      end

      def _ae_set_string_scopeds
        @_ae_in.each do |_in|
          # scope _ae_scopeds_string_attribute_method_name(_in), ->{ where(@_ae_attribute_name => _in) }
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            scope :#{_ae_scopeds_string_attribute_method_name(_in)}, ->{ where(:#{@_ae_attribute_name} => :#{_in}) }
          RUBY
        end
      end
      
      def _ae_set_boolean_scopeds
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          scope :#{@_ae_attribute_name}, ->{ where(:#{@_ae_attribute_name} => true) }
        RUBY
        if @_ae_scopeds.is_a?(Symbol)
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            scope :#{@_ae_scopeds}, ->{ where(:#{@_ae_attribute_name} => false) }
          RUBY
          puts "scope :#{@_ae_scopeds}, ->{ where(:#{@_ae_attribute_name} => false) }"
        end
      end

      def _attribute_name_set_string_validate
        unless @_ae_validate.is_a?(Hash) and !@_ae_validate[:allow_nil].nil?
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            validates :#{@_ae_attribute_name}, presence: true
          RUBY
        end

        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          validates :#{@_ae_attribute_name}, inclusion: {in: #{@_ae_inclusion}}, unless: :"read_attribute(:#{@_ae_attribute_name}).nil?"
        RUBY
      end

      def _attribute_name_set_boolean_text_method
        if @_ae_i18n and defined?(::I18n)
          _attribute_name_set_text_method_with_i18n
        else
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{_ae_text_method_name}
              return '' if read_attribute(:#{@_ae_attribute_name}).nil?
              read_attribute(:#{@_ae_attribute_name}) ? 'Yes' : 'No'
            end
          RUBY
        end
      end

      def _attribute_name_set_string_text_method
        if @_ae_i18n and defined?(::I18n)
          _attribute_name_set_text_method_with_i18n
        else
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{_ae_text_method_name}
              return '' if read_attribute(:#{@_ae_attribute_name}).nil?
              read_attribute(:#{@_ae_attribute_name}).to_s
            end
          RUBY
        end
      end

      def _attribute_name_set_text_method_with_i18n
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{_ae_text_method_name}
            return '' if read_attribute(:#{@_ae_attribute_name}).nil?
            t_str = 'enums.'
            t_str << '#{_ae_i18n_t_prefix}'
            t_str << '#{@_ae_attribute_name}'
            t_str << '.'
            t_str << read_attribute(:#{@_ae_attribute_name}).to_s
            I18n.translate(t_str)
          end
        RUBY
      end

    end
  end

end

