module AttributeEnums
  module Common
    def attribute_enums(attribute_name, options={})
      @_attribute_name = attribute_name.to_s

      @_in = options.has_key?(:in) ? Array(options.delete(:in)) : []
      @_boolean = options.has_key?(:boolean) ? options.delete(:boolean) : false
      @_default = options.has_key?(:default) ? options.delete(:default).to_s : nil
      @_methods = options.has_key?(:methods) ? options.delete(:methods) : false
      @_scopeds = options.has_key?(:scopeds) ? options.delete(:scopeds) : false
      @_validate = options.has_key?(:validate) ? options.delete(:validate) : false
      @_i18n = options.has_key?(:i18n) ? options.delete(:i18n) : false


      # build _in
      if @_boolean
        @_in = [true, false]
        @_inclusion = @_in
      else
        return if @_in.empty?
        @_in = @_in.map{|x| x.to_s.to_sym}.uniq.flatten.delete_if{|y| y.empty?}
        return if @_in.empty?
        @_inclusion = @_in.map{|x| [x, x.to_s]}.flatten
      end

      unless @_default.nil?
        raise 'default value not match' unless @_inclusion.include?(@_default)
      end


      if @_boolean
        _attribute_enums_set_default unless @_default.nil?
        _attribute_enums_set_boolean_scopeds if @_scopeds
        _attribute_name_set_validate if @_validate

        _attribute_name_set_i18n if @_i18n and defined?(::I18n)
      else
        _attribute_enums_set_default unless @_default.nil?
        _attribute_enums_set_string_methods if @_methods
        _attribute_enums_set_string_scopeds if @_scopeds
        _attribute_name_set_i18n if @_i18n and defined?(::I18n)
      end
    end

    private

    def _attribute_enums_valid_prefix?(prefix)
      (prefix.is_a?(String) or prefix.is_a?(Symbol)) and !prefix.empty?
    end

    def _attribute_enums_methods_string_attribute_method_name(_in)
      prefix = ''
      if @_methods.is_a?(Hash)
        _prefix = @_methods[:prefix]
        if (_prefix.is_a?(String) or _prefix.is_a?(Symbol)) and !_prefix.empty?
          prefix = _prefix
        end
      end
      ("%s%s?" % [prefix, _in]).to_sym
    end

    def _attribute_enums_scopeds_string_attribute_method_name(_in)
      prefix = ''
      if @_scopeds.is_a?(Hash)
        _prefix = @_scopeds[:prefix]
        if _attribute_enums_valid_prefix?(_prefix)
          prefix = _prefix
        end
      end
      ("%s%s" % [prefix, _in]).to_sym
    end

    def _attribute_enums_i18n_values_method_name
      ("get_%s_values" % @_attribute_name).to_sym
    end

    def _attribute_enums_i18n_text_method_name
      ("%s_text" % @_attribute_name).to_sym
    end

    def _attribute_enums_i18n_t_prefix
      t_prefix = ''
      if @_scopeds.is_a?(Hash)
        _t_prefix = @_scopeds[:t_prefix]
        t_prefix = _t_prefix if _attribute_enums_valid_prefix?(_t_prefix)
      end
      t_prefix
    end


    def _attribute_name_set_i18n
      if @_boolean
        define_singleton_method _attribute_enums_i18n_values_method_name do
          @_in.map do |_in|
            [I18n.translate(('enums.%s%s.%s' % [_attribute_enums_i18n_t_prefix, @_attribute_name, _in]).to_sym), _in]
          end.sort
        end
      else
        define_singleton_method _attribute_enums_i18n_values_method_name do
          @_in.map do |_in|
            [I18n.translate(('enums.%s%s.%s' % [_attribute_enums_i18n_t_prefix, @_attribute_name, _in]).to_sym), _in.to_s]
          end.sort
        end
      end

      _attribute_name_set_i18n_text
    end

  end
end

