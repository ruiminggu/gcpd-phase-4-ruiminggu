class AssignmentsController < ApplicationController
    before_action :check_authorization, only: [:new, :create, :terminate]
    before_action :check_login
    authorize_resource
  
    def new
        @assignment = Assignment.new
        @officer = Officer.find(params[:officer_id])
        @officer_investigations = Investigation.is_open - @officer.investigations
    end
      
    def create
        @assignment = Assignment.new(assignment_params)
        if @assignment.save
          flash[:notice] = "Successfully added assignment."
          redirect_to officer_path(@assignment.officer)
        else
          @officer = Officer.find(params[:assignment][:officer_id])
          @officer_investigations = Investigation.is_open - @officer.investigations
          render :new
        end
    end
  
    def terminate
      @assignment = Assignment.find(params[:id])
      if @assignment.update(end_date: Date.current)
        flash[:notice] = "Successfully terminated assignment."
        redirect_to officer_path(@assignment.officer)
      end
    end
  
    private
  
    def check_authorization
      if current_user.role == 'officer'
        flash[:error] = "You are not authorized to take this action."
        redirect_to home_path
      end
    end
  
    def assignment_params
        params.require(:assignment).permit(:officer_id, :investigation_id, :start_date, :end_date)
    end
  end
  