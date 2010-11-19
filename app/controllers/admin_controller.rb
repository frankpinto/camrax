class AdminController < ApplicationController
  def index
    if session[:logged_in]
      redirect_to :controller => 'admin/categories', :action => 'list'
    end
  end

  def login
    if params[:username] == 'admin' && params[:password] == 'camrax'
      session[:logged_in] = true
      flash[:notice] = "Successfully logged in."
      redirect_to :action => 'index'
    elsif params.has_key? :username
      flash[:error] = "Incorrect Username and Password"
      redirect_to :action => 'index'
    else
      redirect_to :action => 'index'
    end
  end

  def logout
    session[:logged_in] = false
    redirect_to :action => 'index'
  end
end
