module Shifts
  class Create < ApplicationCommand
    def initialize(params:, shift:)
      @params = params
      @shift = shift
      @contract = Shifts::UpdateContract.new
    end

    def call
      return [:failure, validation_result.errors.to_h] if validation_result.failure?

      shift.update!(shift_attributes)

      [:success, shift]
    end

    private

    attr_reader :contract, :params, :shift

    def shift_attributes
      validation_result.to_h.slice(*Shift.column_names.map(&:to_sym))
    end
  end
end
