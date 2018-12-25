class CurriculumsController < ApplicationController
  # Controller Code
  swagger_controller :curriculums, "Curriculums Management"
  swagger_api :index do
    summary "Fetches all Curriculums"
    notes "This lists all the Curriculums"
  end

  swagger_api :show do
    summary "Shows one Curriculum"
    param :path, :id, :integer, :required, "Curriculum ID"
    notes "This lists details of one curriculum"
    response :not_found
  end

  before_action :set_curriculum, only: [:show]

  # GET /children
  def index
    @curriculums = Curriculum.all

    render json: @curriculums
  end

  # GET /children/1
  def show
    render json: @curriculum
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_curriculum
      @curriculum = Curriculum.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def curriculum_params
      params.permit(:name, :description, :min_rating, :max_rating, :active)
    end
end
