module Workers
  class Create < ApplicationCommand
    def initialize(params:)
      @params = params
      @contract = Workers::CreateContract.new
    end

    def call
      return [:failure, validation_result.errors.to_h] if validation_result.failure?
      worker = Worker.create!(worker_attributes)

      [:success, worker]
    end

    private

    attr_reader :contract, :params

    def worker_attributes
      validation_result.to_h.slice(*Worker.column_names.map(&:to_sym))
    end
  end
end
