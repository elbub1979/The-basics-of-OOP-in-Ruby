module InstanceCounter

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  @@instances_count

  module ClassMethods

    def instances
      InstanceCounter.class_variable_get '@@instances_count'
    end
  end

  module InstanceMethods
    def register_instance
      current_count = InstanceCounter.class_variable_get '@@instances_count'
      InstanceCounter.class_variable_set '@@instances_count', current_count + 1
    end
  end
end
