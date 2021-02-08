class SyndromesController < ApplicationController
  before_action :set_syndrome, only: [:show, :update, :destroy]
  before_action :set_symptoms, only: [ :create ]
  #before_action :authenticate_admin!, except: %i[ index ]
  load_and_authorize_resource

  # GET /syndromes
  def index
    @user = current_admin || current_manager || current_user
    @syndromes = Syndrome.filter_syndrome_by_app_id(@user.app_id)

    render json: @syndromes
  end

  # GET /syndromes/1
  def show
    render json: @syndrome
  end

  # POST /syndromes
  def create
    @symptoms = syndrome_params[:symptom]
    @syndrome = Syndrome.new(syndrome_params.except(:symptom))
    if @syndrome.save
      unless @symptoms.nil?
        create_or_update_symptoms
      end
      render json: @syndrome, status: :created, location: @syndrome
    else
      render json: @syndrome.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /syndromes/1
  def update
    @symptoms = syndrome_params[:symptom]
    if @syndrome.update(syndrome_params.except(:symptom))
      unless @symptoms.nil?
        create_or_update_symptoms
      end
      render json: @syndrome
    else
      render json: @syndrome.errors, status: :unprocessable_entity
    end
  end

  # DELETE /syndromes/1 
  def destroy
    @syndrome.destroy
  end

  private
    def create_or_update_symptoms
      @symptoms.each do |symptom|
        created_symptom = create_sympton_connections symptom
        create_or_update_connection symptom[:percentage], created_symptom
      end
    end

    def create_sympton_connections(symptom)
      Symptom.find_or_create_by!(description: symptom[:description]) do |symptom_data|
        symptom_data.code = symptom[:code]
        symptom_data.details = symptom[:details]
        symptom_data.priority = symptom[:priority]
        symptom_data.app_id = symptom[:app_id] || current_admin.app_id
      end
    end

    def create_or_update_connection(percentage, symptom)
      SyndromeSymptomPercentage.where(symptom: symptom, syndrome: @syndrome).first_or_create do |symptom_percentage|
          symptom_percentage.percentage = percentage || 0
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_syndrome
      @syndrome = Syndrome.find(params[:id])
    end

    def set_symptoms
       @symptoms = params[:symptoms]
    end

    # Only allow a trusted parameter "white list" through.
    def syndrome_params
      params.require(:syndrome).permit(
        :description,
        :details,
        :app_id,
        :symptom => [[:description,:code,:percentage,:details,:priority,:app_id]],
        message_attributes: [  :title, :warning_message, :go_to_hospital_message ]
      )
    end
end
