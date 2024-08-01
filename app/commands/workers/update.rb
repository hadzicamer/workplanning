module Workers
  class Update < ApplicationCommand
    def initialize(params:, worker:)
      @params = params
      @worker = worker
      @contract = Workers::UpdateContract.new
    end

    def call
      return [:failure, validation_result.errors.to_h] if validation_result.failure?

      worker.update!(worker_attributes)

      [:success, worker]
    end

    private

    attr_reader :contract, :params, :worker

    def worker_attributes
      validation_result.to_h.slice(*Worker.column_names.map(&:to_sym))
    end
  end
end
