class SessionsController < ApplicationController
    def new
      # This action just renders the new.html.erb template where the login form should be
    end
  
    def create
      officer = Officer.find_by(username: params[:username])
      # Assuming Officer model has an 'authenticate' method to verify password correctness
      if officer&.authenticate(params[:password])
        session[:officer_id] = officer.id
        redirect_to home_path, notice: "Logged in!"
      else
        flash.now[:alert] = "Username and/or password is invalid"
        render :new
      end
    end
  
    def destroy
      session[:officer_id] = nil
      redirect_to home_path, notice: "Logged out!"
    end
  end
  