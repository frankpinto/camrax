class Admin::CategoriesController < ApplicationController
  layout 'admin'
  before_filter :init_layout

  def init_layout
    @title = 'Categories'
  end

  def index
    @categories = Category.find(:all, :order => 'created_at ASC', :limit => '10')
    @category = Category.new
    @category.languages = [Language.new]
    @subtitle = 'Dashboard'
  end

  def list
    @categories = Category.find(:all, :order => 'title ASC')
    @subtitle = 'View All'
    render :partial => 'list', :layout => 'admin'
  end

  def edit
    @cat = Category.find params[:id]
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
    #@subtitle = 'Testing'
    @text = session.inspect
  end
end
