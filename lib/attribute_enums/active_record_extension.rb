module AttributeEnums
  module ActiveRecordExtension
    extend ActiveSupport::Concern
    included do
      extend ClassMethods
    end
    module ClassMethods
      def attribute_enums(attribute_name, *options, &block)
        attribute_name = attribute_name.to_s
        options = options.extract_options!
        within = options.delete(:in).to_a || options.delete(:within).to_a || []
        scopes = options.delete(:scopes) || true
        allow_blank = options.delete(:allow_blank) || false
        use_validate = options.delete(:validate) || true
        methods = options.delete(:methods) || true
        i18n = options.delete(:i18n) || true
        booleans = options.delete(:booleans) || false
        default = options.delete(:default) || (booleans ? true : "")

        raise "attribute #{ attribute_name } does not exist." unless column_names.index(attribute_name)
        raise "in/within and booleans has one and only one exist." if (!within.blank? and !booleans.blank?) or
                                                               (within.blank? and booleans.blank?)
        if booleans
          within = [true, false]
        else
          within.keep_if{|x| x.respond_to?("to_sym")}.collect!(&:to_s)
        end

        attribute_values = Hash[ within.map {|x| [ x, i18n ? I18n.translate(:"#{self.i18n_scope}.enums.#{self.model_name.underscore}.#{ attribute_name }.#{ x }") : x ]} ]
        eval(%Q`class_attribute :#{ attribute_name}_values`)
        eval(%Q`self.#{ attribute_name}_values = #{ attribute_values }`)

        if scopes
          if booleans
            scope attribute_name, where(attribute_name => true)
            eval(%Q`scope :not_#{ attribute_name }, where(:#{ attribute_name } => false)`)
          else
            within.all? do |value|
              scope value, where(attribute_name => value)
            end
          end
        end

        unless allow_blank
          validates attribute_name, :presence => true
        end

        if use_validate
          validates attribute_name, :inclusion => { :in => booleans ? [true, false] : (within + within.collect{|x| x.to_sym}) },
                                    :if => eval(%Q`Proc.new { |record| record.#{ attribute_name }? }`)
        end

        if methods
          eval(%Q`def get_#{ attribute_name }_values; self.#{ attribute_name}_values.to_a; end`)
          if booleans
            class_eval(%Q`def #{ attribute_name }_text; self.class.#{ attribute_name}_values[read_attribute("#{ attribute_name }")]; end`)
          else
            class_eval(%Q`def #{ attribute_name }_text; self.class.#{ attribute_name}_values[read_attribute("#{ attribute_name }").to_s]; end`)
          end
          unless booleans
            within.each {|name| class_eval(%Q`def #{ name }?; read_attribute("#{ attribute_name }").to_s == "#{ name }"; end`) }
          end
        end

        if default
          if booleans
            class_eval(%Q`def set_default_for_attr_#{ attribute_name }; self.#{ attribute_name } ||= #{ !default.blank? }; end`)
          else
            class_eval(%Q`def set_default_for_attr_#{ attribute_name }; self.#{ attribute_name } ||= "#{ default.to_s }"; end`)
          end
          eval(%Q`before_validation :set_default_for_attr_#{ attribute_name }`)
        end
      end
    end
    module InstanceMethods
    end
  end

end

