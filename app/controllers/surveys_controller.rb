# frozen_string_literal: true

class SurveysController < ApplicationController
  before_action :authenticate_user!, except: %i[render_without_user all_surveys limited_surveys]
  before_action :set_survey, only: %i[show update destroy]
  before_action :set_user, only: %i[index create]

  @WEEK_SURVEY_CACHE_EXPIRATION = 15.minute
  @LIMITED_SURVEY_CACHE_EXPIRATION = 15.minute

  # GET /surveys
  # GET user related surveys
  def index
    @surveys = Survey.filter_by_user(current_user.id)

    render json: @surveys, each_serializer: SurveyDailyReportsSerializer
  end

  # GET /all_surveys
  def all_surveys
    @surveys = Survey.all

    render json: @surveys
  end

  # GET /surveys/1
  def show
    render json: @survey
  end

  # POST /surveys
  def create
    date = DateTime.now.in_time_zone(Time.zone).beginning_of_day
    past_surveys = Survey.filter_by_user(current_user.id).where('created_at >= ?', date)

    @survey = Survey.new(survey_params)
    @survey.user_id = @user.id

    if past_surveys.length == 2
      render json: { errors: 'The user already contributed two times today' }, status: :unprocessable_entity
    elsif past_surveys[0] && past_surveys[0].symptom[0] && @survey.symptom[0]
      render json: { errors: 'The user already contributed with this survey today' }, status: :unprocessable_entity
    elsif past_surveys[0] && !past_surveys[0].symptom[0] && !@survey.symptom[0]
      render json: { errors: 'The user already contributed with this survey today' }, status: :unprocessable_entity
    else
      if @survey.save
        render json: @survey, status: :created, location: user_survey_path(id: @user)
      else
        render json: @survey.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /surveys/1
  def destroy
    @survey.destroy
  end

  def weekly_surveys
    # Rails.cache.fetch tries to get that key 'week_surveys', if it fails,
    # it runs the block and sets the cache as the return of the block
    json = Rails.cache.fetch('week_surveys', expires_in: @WEEK_SURVEY_CACHE_EXPIRATION) do
      render_to_string json: @surveys = Survey.where('created_at >= ?', 1.week.ago.utc), each_serializer: SurveyForMapSerializer
    end

    render json: json, each_serializer: SurveyForMapSerializer
  end

  def render_without_user
    @surveys = Survey.all

    render json: @surveys, each_serializer: SurveyWithoutUserSerializer
  end

  def limited_surveys
    # Rails.cache.fetch tries to get that key 'limited_surveys', if it fails,
    # it runs the block and sets the cache as the return of the block
    json = Rails.cache.fetch('limited_surveys', expires_in: @LIMITED_SURVEY_CACHE_EXPIRATION) do
      render_to_string json: @surveys = Survey.where('created_at >= ?', 12.hour.ago.utc), each_serializer: SurveyForMapSerializer
    end

    render json: json, root: 'surveys', each_serializer: SurveyForMapSerializer
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_survey
    @survey = Survey.find(params[:id])
  end

  def set_user
    @user = User.find(current_user.id)
  end

  # Only allow a trusted parameter "white list" through.
  def survey_params
    params.require(:survey).permit(
      :user_id,
      :household_id,
      :latitude,
      :longitude,
      :bad_since,
      :traveled_to,
      :street,
      :city,
      :state,
      :country,
      :went_to_hospital,
      :contact_with_symptom,
      symptom: []
    )
  end
end
