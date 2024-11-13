class InvestigationsController < ApplicationController
    before_action :set_investigation, only: [:show, :edit, :update, :close]
    before_action :check_login
    authorize_resource
  
    def index
      @open_investigations = Investigation.is_open.alphabetical.paginate(page: params[:page]).per_page(10)
      @closed_investigations = Investigation.is_closed
      @closed_unsolved = Investigation.is_closed.where(solved: false)
      @with_batman = Investigation.with_batman
      @unassigned_cases = Investigation.unassigned
    end
  
    def new
      @investigation = Investigation.new
    end
  
    def create
      @investigation = Investigation.new(investigation_params)
      if @investigation.save
        flash[:notice] = "Successfully added '#{@investigation.title}' to GCPD."
        redirect_to investigation_path(@investigation)
      else
        render :new
      end
    end
  
    def show
      @current_assignments = @investigation.assignments.where(end_date: nil)
    end
  
    def edit
    end
  
    def update
      if @investigation.update(investigation_params)
        redirect_to investigation_path(@investigation), notice: 'Investigation was successfully updated.'
      else
        render :edit
      end
    end
  
    def close
      if @investigation.update(date_closed: Date.current, solved: true) # Assuming closure implies solving
        flash[:notice] = 'Investigation has been closed.'
        redirect_to investigations_path
      end
    end
  
    private
  
    def set_investigation
      @investigation = Investigation.find(params[:id])
    end
  
    def investigation_params
      params.require(:investigation).permit(:title, :description, :crime_location, :date_opened, :date_closed, :solved, :batman_involved)
    end
  end
  