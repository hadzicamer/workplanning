module Shifts
  class UpdateContract < ApplicationContract
    json do
      optional(:start_time).maybe(:date_time)
      optional(:end_time).maybe(:date_time)
      optional(:worker_id).maybe(:integer)
    end

    rule(:start_time, :end_time) do
      if values[:start_time] && values[:end_time] && (values[:end_time] - values[:start_time]) != 8.hours
        key(:end_time).failure("Shift must be exactly 8 hours long")
      end
    end

    rule(:worker_id, :start_time) do
      if values[:worker_id] && values[:start_time]
        worker = Worker.find_by(id: values[:worker_id])
        if worker&.shifts&.any? { |s| s.start_time.to_date == values[:start_time].to_date && s.id != values[:id] }
          key(:start_time).failure("Worker cannot have two shifts on the same day")
        end
      end
    end
  end
end
