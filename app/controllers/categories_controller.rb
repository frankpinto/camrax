class CategoriesController < ApplicationController
  before_filter :verify_login, :only => [:edit, :new, :list]

  def index
  end

  def show
    @category = Category.find params[:id]
    @width = '33%' #@category.modern ? '33%' : '50%'
  end

end
