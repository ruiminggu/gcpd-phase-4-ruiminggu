class UnitsController < ApplicationController
    before_action :set_unit, only: [:show, :edit, :update, :destroy]
    before_action :check_login
    authorize_resource
  
    def index
      @active_units = Unit.where(active: true).alphabetical.paginate(page: params[:page]).per_page(20)
      @inactive_units = Unit.where(active: false).alphabetical.paginate(page: params[:page]).per_page(20)
    end
  
    def new
      @unit = Unit.new
    end
  
    def create
      @unit = Unit.new(unit_params)
      if @unit.save
        flash[:notice] = "Successfully added #{@unit.name} to GCPD."
        redirect_to units_path
      else
        render :new
      end
    end
  
    def show
      @unit = Unit.find(params[:id])
      @officers = @unit.officers.where(active: true).alphabetical.paginate(page: params[:page]).per_page(10)
    end
  
    def edit
    end
  
    def update
      @unit = Unit.find(params[:id])
      if @unit.update(unit_params)
        redirect_to unit_path(@unit), notice: "Updated unit information."
      else
        render :edit
      end
    end
  
    def destroy
        if @unit.officers.any?
          @active_units = Unit.where(active: true)
          @inactive_units = Unit.where(active: false)
          flash.now[:alert] = "Cannot remove a unit with officers assigned." # Optional: display a message
          render 'index'
        else
          @unit.destroy
          redirect_to units_path, notice: "Removed #{@unit.name} from the system."
        end
    end
      
  
    private
  
    def set_unit
      @unit = Unit.find(params[:id])
    end
  
    def unit_params
      params.require(:unit).permit(:name, :active)
    end
end
  