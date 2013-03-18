require 'active_model'
require 'active_support/all'

class Person

  attr_accessor :gender

  include ActiveModel::AttributeMethods
  attribute_method_suffix '?'
  define_attribute_methods ['gender']

  include ActiveModel::Validations

  private

  def attribute?(attr)
    send(attr).present?
  end

end

