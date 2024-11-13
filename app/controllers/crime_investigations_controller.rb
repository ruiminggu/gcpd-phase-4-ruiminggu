class CrimeInvestigationsController < ApplicationController
    before_action :set_crime_investigation, only: [:destroy]
    before_action :check_login
    authorize_resource
  
    def new
        @investigation = Investigation.find(params[:investigation_id])
        @crime_investigation = CrimeInvestigation.new
        @crimes_list = Crime.all
    end
  
  
    def create
        @crime_investigation = CrimeInvestigation.new(crime_investigation_params)
        if @crime_investigation.save
          redirect_to investigation_path(@crime_investigation.investigation), notice: "Successfully added #{@crime_investigation.crime.name} to #{@crime_investigation.investigation.title}."
        else
          @investigation = @crime_investigation.investigation
          @crimes_list = Crime.all - @investigation.crimes
          render :new
        end
    end
  
    def destroy
      investigation = @crime_investigation.investigation
      if @crime_investigation.destroy
        flash[:notice] = "Successfully removed a crime from this investigation."
        redirect_to investigation_path(investigation)
      end
    end
  
    private
  
    def set_crime_investigation
      @crime_investigation = CrimeInvestigation.find(params[:id])
    end
  
    def crime_investigation_params
      params.require(:crime_investigation).permit(:crime_id, :investigation_id)
    end
  end
  