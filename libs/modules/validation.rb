module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  VALIDATION_METHODS = {
    presence: :validate_presence,
    format: :validate_format,
    type: :validate_type,
    length: :validate_length
  }.freeze

  module ClassMethods
    def validate(object, attribute, validation_type, *args)
      method_name = VALIDATION_METHODS[validation_type]

      raise ArgumentError, "такой валидации не существует: #{validation_type}" unless method_name

      send(method_name, object, attribute, *args)
    end

    private

    def validate_presence(object, attribute)
      value = value(object, attribute)

      raise StandardError, "Атрибут #{attribute} не может быть пустым" if value.nil? || value.to_s.empty?

      true
    end

    def validate_format(object, attribute, regex)
      value = value(object, attribute)

      raise StandardError, 'Значение не соотвествует шаблону' unless value =~ regex

      true
    end

    def validate_type(object, attribute, klass)
      value = value(object, attribute)

      raise StandardError, 'Несоотвествие типов переменной и класса' unless value.is_a?(klass)

      true
    end

    def validate_length(object, attribute, *params)
      value = value(object, attribute)
      params_method = params.first
      params_value = params.last

      case params_method
      when :minimum
        raise StandardError, "Не может быть меньше: #{params_value}" if value < params_value
      when :maximum
        raise StandardError, "Не может быть больше: #{params_value}" if value > params_value
      else
        raise StandardError, 'Атрибут не определен'
      end

      true
    end

    def value(object, attribute)
      object.send(attribute)
    end
  end

  module InstanceMethods
    def validate!
      self.class.validate_attributes(self)
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end
  end
end
