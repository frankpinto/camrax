class AdminController < ApplicationController
  def index
    if session[:logged_in]
      redirect_to :controller => 'cateogires' action => 'list'
    end
  end

  def login
    if params[:username] == 'admin' && params[:password] == 'camrax'
      session[:logged_in] = true
      flash[:notice] = "Successfully logged in."
      redirect_to :action => 'panel'
    else
      flash[:error] = "Incorrect Username and Password"
      redirect_to :action => 'index'
    end
  end

  def logout
    session[:logged_in] = false
    redirect_to :action => 'index'
  end
end
