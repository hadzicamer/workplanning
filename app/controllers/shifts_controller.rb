class ShiftsController < ApplicationController
  before_action :shift, only: [:show, :update, :destroy]

  def index
    @shifts = Shift.all
    render json: @shifts
  end

  def show
    render json: shift, serializer: ShiftSerializer, status: :ok
  end

  def create
    result = Shifts::Create.call(params: permitted_params)
    render_command_result(result, serializer: ShiftSerializer, status: :created)
  end

  def update
    result = Shifts::Update.call(params: permitted_params, shift:)
    render_command_result(result, serializer: ShiftSerializer, status: :ok)
  end

  def destroy
    @shift.destroy
  end

  private

  def shift
    @shift ||= Shift.find_by!(id: params[:id])
  end
end
