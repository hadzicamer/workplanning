module Shifts
  class CreateContract < ApplicationContract
    json do
      optional(:start_time).maybe(:date_time)
      optional(:end_time).maybe(:date_time)
      optional(:worker_id).maybe(:integer)
    end

    rule(:start_time, :end_time) do
      if values[:start_time] && values[:end_time]
        start_time_utc = values[:start_time].in_time_zone("UTC")
        end_time_utc = values[:end_time].in_time_zone("UTC")

        duration = end_time_utc - start_time_utc

        unless duration == 8.hours
          key(:end_time).failure("Shift must be exactly 8 hours long")
        end
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

    rule(:start_time) do
      if values[:start_time]
        start_time = values[:start_time].in_time_zone("UTC")

        allowed_start_hours = [0, 8, 16]
        unless allowed_start_hours.include?(start_time.hour) && start_time.min == 0 && start_time.sec == 0
          key(:start_time).failure("Shift must start at 0:00, 8:00, or 16:00")
        end
      end
    end
  end
end
