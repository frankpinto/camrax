class Admin::CategoriesController < ApplicationController
  layout 'admin'
  before_filter :init_layout
  before_filter :verify_login, :only => [:index, :edit, :new, :list]

  def init_layout
    @title = 'Categories'
    @cat_expanded = true
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
    @category = Category.find params[:id]
    @subtitle = 'Edit ' + @category.title
  end

  def update
    @cat = Category.find params[:id]
    @cat.modified_at = Time.now
    if @cat.update_attributes params[:category]
      redirect_to '/categories/' + params[:id].to_s
    else
      flash[:error] =  'Problem updating Category.'
      render 'edit'
    end
  end

  def create
    @category = Category.new params[:category]

    if @category.save
      redirect_to '/categories/' + params[:id].to_s
    else
      render 'new'
    end
  end

  def destroy
    @category = Category.find(params[:id])

    if @category.destroy
      flash[:notice] =  'Category successfully deleted.'
    else
      flash[:error] =  'Category couldn\'t be deleted.'
    end

    redirect_to :action => 'list'
  end

  def new
    @category = Category.new
    @category.languages = [Language.new]
    @subtitle = 'Add A Category'
  end

  def debug
    @subtitle = 'Testing'
    @text = session.inspect
  end

  def search
    respond_to do |format|
      format.js do 
        cats = Category.find(:all, :conditions => ['title LIKE ?', '%' + params[:term] + '%'], :limit => 5, :order => 'title ASC')
        options = cats.collect {|cat| {:label => cat.title, :value => '', :id => cat.id}}
        options = [{:label => 'No Matches', :value => '', :id => ''}] if cats.empty?
        render :text => options.to_json
      end
    end
  end
end
