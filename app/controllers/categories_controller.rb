class CategoriesController < ApplicationController
  def index
  end

  def show
    @category = Category.find params[:id], :include => :redirect
    if !@category.redirect.blank?
      redirect_to :action => 'show', :id => @category.redirect.id
    end
    @width = '33%' #@category.modern ? '33%' : '50%'
  end

end
