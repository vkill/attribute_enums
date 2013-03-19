require 'active_model'
require 'active_support/all'

class Person

  attr_accessor :gender, :enable

  include ActiveModel::AttributeMethods
  attribute_method_suffix '?'
  define_attribute_methods ['gender']

  include ActiveModel::Validations

  extend ActiveModel::Callbacks
  define_model_callbacks :validation

  private
  
  def attribute?(attr)
    send(attr).present?
  end

  def read_attribute(attr)
    send(attr)
  end

  def write_attribute(attr, value)
    send("#{attr}=", value)
  end


end

