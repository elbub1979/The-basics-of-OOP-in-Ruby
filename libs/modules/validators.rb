# frozen_string_literal: true

module Validators
  def valid?
    validate!
    true
  rescue StandardError
    false
  end
end
