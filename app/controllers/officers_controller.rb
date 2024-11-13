class OfficersController < ApplicationController
    before_action :set_officer, only: [:show, :edit, :update, :destroy]
    before_action :check_update, only: [:edit, :update]
    before_action :check_show, only: [:show]
    before_action :check_login
    authorize_resource
  
    def index
      @active_officers = Officer.where(active: true).alphabetical.paginate(page: params[:page]).per_page(20)
      @inactive_officers = Officer.where(active: false).alphabetical.paginate(page: params[:page]).per_page(20)
    end
  
    def new
      @officer = Officer.new
    end
  
    def create
      @officer = Officer.new(officer_params)
      if @officer.save
        flash[:notice] = "Successfully created #{@officer.first_name} #{@officer.last_name}."
        redirect_to officer_path(@officer)
      else
        render :new
      end
    end
  
    def show
      @current_assignments = @officer.assignments.where(end_date: nil)
      @past_assignments = @officer.assignments.where.not(end_date: nil)
    end
  
    def edit
    end
  
    def update
      if @officer.update(officer_params)
        redirect_to officer_path(@officer), notice: "Officer was successfully updated."
      else
        render :edit
      end
    end
  
    def destroy
      if @officer.destroy
        flash[:notice] = "Removed #{@officer.proper_name} from the system."
        redirect_to officers_path
      else
        render :show
      end
    end
  
    private
  
    def set_officer
      @officer = Officer.find(params[:id])
    end

    def check_update
      unless ((current_user.unit == @officer.unit && current_user.role == 'chief') || current_user.role == 'commish')
          flash[:error] = "You are not authorized to take this action."
          redirect_to home_path
      end
    end

    def check_show
        unless current_user.role == 'chief' || current_user == @officer || current_user.role == 'commish'
            flash[:error] = "You are not authorized to take this action."
            redirect_to home_path
        end
    end
  
    def officer_params
      params.require(:officer).permit(:active, :ssn, :rank, :first_name, :last_name, :unit_id, :username, :password, :password_confirmation, :role)
    end
  end
  