class CrimesController < ApplicationController
    before_action :set_crime, only: [:edit, :update]
    before_action :check_login
    authorize_resource
  
    def index
      @active_crimes = Crime.where(active: true)
      @inactive_crimes = Crime.where(active: false)
    end
  
    def new
      @crime = Crime.new
    end
  
    def create
      @crime = Crime.new(crime_params)
      if @crime.save
        flash[:notice] = "Successfully added #{@crime.name} to GCPD."
        redirect_to crimes_path
      else
        render :new
      end
    end
  
    def edit
    end
  
    def update
      if @crime.update(crime_params)
        redirect_to crimes_path, notice: "Crime was successfully updated."
      else
        render :edit
      end
    end
  
    private
  
    def set_crime
      @crime = Crime.find(params[:id])
    end
  
    def crime_params
      params.require(:crime).permit(:name, :active)
    end
  end
  