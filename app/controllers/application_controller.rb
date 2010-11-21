# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :menu

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def menu
    cats = Category.find(:all, :order => 'title ASC')
    @menu_categories = {}
    @alphabet = ('a'..'z').to_a
    cats.each do |category|
      @menu_categories[category.title[0...1].downcase] = [] if @menu_categories[category.title[0...1].downcase].nil?
      @menu_categories[category.title[0...1].downcase] << category
    end
  end

  def logged_in?
    session[:logged_in]
  end

  def verify_login
    unless logged_in?
      flash[:error] = "This action requires login."
      redirect_to :controller => '/admin', :action => 'login' 
    end
  end

  def self.require_login actions
    if actions.class == Array
      actions.each do |action|
        before_filter {|controller| verify_login if controller.action_name == action}
      end
    elsif actions.class == String || actions.class == Symbol
        before_filter {|controller| verify_login if controller.action == actions}
    else
      raise ArgumentError, "Action for require_login has to be Array, String or Symbol"
    end
  end
end
