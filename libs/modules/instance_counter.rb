# frozen_string_literal: true

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  @@instances_count = 0

  module ClassMethods
    def instances
      InstanceCounter.class_variable_get '@@instances_count'
    end
  end

  module InstanceMethods
    private

    def register_instance
      current_count = InstanceCounter.class_variable_get '@@instances_count'
      InstanceCounter.class_variable_set '@@instances_count', current_count + 1
    end
  end
end
