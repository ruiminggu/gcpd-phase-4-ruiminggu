class SuspectsController < ApplicationController
    before_action :check_login
    authorize_resource
    
    def new
        @suspect = Suspect.new
        @investigation = Investigation.find(params[:investigation_id])
        @current_suspects = @investigation.suspects.current
    end
  
    def create
      @suspect = Suspect.new(suspect_params)
      if @suspect.save
        flash[:notice] = "Successfully added suspect."
        redirect_to investigation_path(@suspect.investigation)
      else
        @investigation = Investigation.find(params[:suspect][:investigation_id])
        @current_suspects = @investigation.suspects.current
        render action: 'new'
      end
    end

    def terminate
        @suspect = Suspect.find(params[:id])
        @suspect.update(dropped_on: Date.current)
        @suspect.save
        redirect_to investigation_path(@suspect.investigation)
    end
  
    private
  
    def suspect_params
      params.require(:suspect).permit(:criminal_id, :investigation_id, :added_on)
    end
end