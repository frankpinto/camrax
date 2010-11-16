class CategoriesController < ApplicationController
  def index
  end

  def list
    @categories = Category.find(:all, :order => 'title ASC')
  end

  def show
    @category = Category.find params[:id]
    @width = '33%' #@category.modern ? '33%' : '50%'
  end

  def edit
    @cat = Category.find params[:id]
    render 'edit'
  end

  def update
    @cat = Category.find params[:id]
    @cat.update_attributes! params[:category]

    redirect_to '/categories/' + params[:id].to_s
  end

  def create
    c = Category.new params[:category]

    if c.save
      render :text => 'success!'
    else
      render :text => 'fuck!'
    end
  end

  def destroy
    render :text => "This is destroy!"
  end

  def new
    @cat = Category.new
    @cat.languages = [Language.new]
  end

  def debug
    render :text => session.inspect
  end
end
