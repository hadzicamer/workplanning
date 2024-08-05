module Shifts
  class Create < ApplicationCommand
    def initialize(params:)
      @params = params.merge(worker_id: params[:worker_id].to_i)
      @contract = Shifts::CreateContract.new
    end

    def call
      return [:failure, validation_result.errors.to_h] if validation_result.failure?

      shift = Shift.create!(shift_attributes)

      [:success, shift]
    end

    private

    attr_reader :contract, :params

    def shift_attributes
      validation_result.to_h.slice(*Shift.column_names.map(&:to_sym))
    end
  end
end
