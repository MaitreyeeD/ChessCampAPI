class InstructorsController < ApplicationController
  # Controller Code
  swagger_controller :instructors, "Instructors Management"
  swagger_api :index do
    summary "Fetches all Instructors"
    notes "This lists all the Instructors"
  end

  swagger_api :show do
    summary "Shows one Instructor"
    param :path, :id, :integer, :required, "Instructor ID"
    notes "This lists details of one instructor"
    response :not_found
  end

  before_action :set_instructor, only: [:show]

  # GET /children
  def index
    @instructors = Instructor.all

    render json: @instructors
  end

  # GET /children/1
  def show
    render json: @instructor
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_instructor
      @instructor = Instructor.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def instructor_params
      params.permit(:first_name, :last_name, :bio, :active)
    end
end
