class WorkersController < ApplicationController
  def index
    @workers = Worker.all
    render json: @workers
  end

  def show
    render json: worker, serializer: WorkerSerializer, status: :ok
  end

  def create
    result = Workers::Create.call(params: permitted_params)
    render_command_result(result, serializer: WorkerSerializer, status: :created)
  end

  def update
    result = Workers::Update.call(params: permitted_params, worker:)
    render_command_result(result, serializer: WorkerSerializer, status: :ok)
  end

  def destroy
    @worker.destroy
  end

  private

  def worker
    @worker ||= Worker.find_by!(id: params[:id])
  end
end
