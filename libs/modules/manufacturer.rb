# frozen_string_literal: true

module Manufacturer
  attr_accessor :manufacturer

  def add_manufacturer(name)
    @manufacturer = name
  end
end
