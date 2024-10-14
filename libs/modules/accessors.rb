module Accessors
  def attr_accessors_with_history(*attrs)
    attrs.each do |attr|
      attr_name = "@#{attr}"

      instance_variable_set(attr_name, [])

      define_method(attr_name.to_sym { instance_variable_get(attr_name.last) })
      define_method("#{attr_name}=".to_sym { |value| attr_name << value })

      define_method("#{attr_name}_history").to_sym { attr_name }
    end
  end

  def strong_attr_accessor(*data)
    attr_name = data[0]
    class_name = data[1]

    define_method(attr_name.to_sym { instance_variable_get(attr_name) })

    define_method("#{attr_name}=".to_sym do |value|
      raise StandardError, 'несоответствие типов переменной и класса' unless value.instance_of?(class_name)

      instance_variable_set(attr_name, value)
    end)
  end
end
