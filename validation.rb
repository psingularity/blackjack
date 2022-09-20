# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validations
      @validations ||= []
    end

    def validate(var_name, validation_type, params = nil)
      validations << { var_name: var_name, validation_type: validation_type, params: params }
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue RuntimeError
      false
    end

    private

    def validate!
      validations = self.class.validations
      validations.each do |validation|
        var_validation = instance_variable_get("@#{validation[:var_name]}")
        send "validate_#{validation[:validation_type]}", var_validation, validation[:params]
      end
    end

    def validate_presence(var_validation, _)
      raise 'Значение не должно быть nil или пустой строкой' if ['', nil].include? var_validation
    end
  end
end
