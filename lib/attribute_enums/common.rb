module AttributeEnums
  module Common

    def attribute_enums(attribute_name, options={})
      _ae_init_instance_variables

      @_ae_attribute_name = attribute_name.to_s

      @_ae_in = options.has_key?(:in) ? Array(options.delete(:in)) : []
      @_ae_boolean = options.has_key?(:boolean) ? options.delete(:boolean) : false
      @_ae_default = options.has_key?(:default) ? options.delete(:default) : nil
      @_ae_ask_methods = options.has_key?(:ask_methods) ? options.delete(:ask_methods) : false
      @_ae_scopeds = options.has_key?(:scopeds) ? options.delete(:scopeds) : false
      @_ae_validate = options.has_key?(:validate) ? options.delete(:validate) : false
      @_ae_i18n = options.has_key?(:i18n) ? options.delete(:i18n) : false


      # build _in
      if @_ae_boolean
        @_ae_in = [true, false]
        @_ae_inclusion = @_ae_in
      else
        return if @_ae_in.empty?
        @_ae_in = @_ae_in.map{|x| x.to_s.to_sym}.uniq.flatten.delete_if{|y| y.empty?}
        return if @_ae_in.empty?
        @_ae_inclusion = @_ae_in.map{|x| [x, x.to_s]}.flatten
      end

      unless @_ae_default.nil?
        raise 'default value not match' unless @_ae_inclusion.include?(@_ae_default)
      end

      _ae_set_default unless @_ae_default.nil?
      if @_ae_scopeds
        if @_ae_boolean
          _ae_set_boolean_scopeds
        else
          _ae_set_string_scopeds
        end
      end

      
      if @_ae_boolean
        _attribute_name_set_boolean_values_method
        _attribute_name_set_boolean_text_method
      else
        _attribute_name_set_string_values_method
        _attribute_name_set_string_text_method
      end
      

      unless @_ae_boolean
        _ae_set_string_ask_methods if @_ae_ask_methods
        _attribute_name_set_string_validate if @_ae_validate
      end

      _ae_remove_instance_variables
    end



    private

    def _ae_instance_variable_names
      %w(attribute_name in boolean default ask_methods scopeds validate i18n inclusion)
    end

    def _ae_init_instance_variables
      _ae_instance_variable_names.each do |name|
        instance_variable_set "@_ae_#{name}", nil
      end
    end

    def _ae_remove_instance_variables
      _ae_instance_variable_names.each do |name|
        remove_instance_variable "@_ae_#{name}"
      end
    end

    def _ae_valid_prefix?(prefix)
      (prefix.is_a?(String) or prefix.is_a?(Symbol)) and !prefix.empty?
    end

    def _ae_ask_methods_string_attribute_method_name(_in)
      prefix = ''
      if @_ae_ask_methods.is_a?(Hash)
        _prefix = @_ae_ask_methods[:prefix]
        if (_prefix.is_a?(String) or _prefix.is_a?(Symbol)) and !_prefix.empty?
          prefix = _prefix
        end
      end
      ("%s%s?" % [prefix, _in]).to_sym
    end

    def _ae_scopeds_string_attribute_method_name(_in)
      prefix = ''
      if @_ae_scopeds.is_a?(Hash)
        _prefix = @_ae_scopeds[:prefix]
        if _ae_valid_prefix?(_prefix)
          prefix = _prefix
        end
      end
      ("%s%s" % [prefix, _in]).to_sym
    end

    def _ae_values_method_name
      ("get_%s_values" % @_ae_attribute_name).to_sym
    end

    def _ae_text_method_name
      ("%s_text" % @_ae_attribute_name).to_sym
    end

    def _ae_i18n_t_prefix
      t_prefix = ''
      if @_ae_i18n.is_a?(Hash)
        _t_prefix = @_ae_i18n[:t_prefix]
        t_prefix = _t_prefix if _ae_valid_prefix?(_t_prefix)
      end
      t_prefix
    end


    def _attribute_name_set_boolean_values_method
      if @_ae_i18n and defined?(::I18n)
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def self.#{_ae_values_method_name}
            #{@_ae_in}.map do |_in|
              [I18n.translate('enums.%s%s.%s' % ['#{_ae_i18n_t_prefix}', :#{@_ae_attribute_name}, _in]), _in]
            end
          end
        RUBY
      else
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def self.#{_ae_values_method_name}
            #{@_ae_in}.map do |_in|
              [(_in ? 'Yes' : 'No'), _in]
            end
          end
        RUBY
      end
    end

    def _attribute_name_set_string_values_method
      if @_ae_i18n and defined?(::I18n)
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def self.#{_ae_values_method_name}
            #{@_ae_in}.map do |_in|
              [I18n.translate('enums.%s%s.%s' % ['#{_ae_i18n_t_prefix}', :#{@_ae_attribute_name}, _in]), _in.to_s]
            end
          end
        RUBY
      else
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def self.#{_ae_values_method_name}
            #{@_ae_in}.map do |_in|
              [_in.to_s, _in.to_s]
            end
          end
        RUBY
      end
    end



  end
end

