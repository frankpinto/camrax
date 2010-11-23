class Admin::CategoriesController < ApplicationController
  layout 'admin'
  before_filter :init_layout
  before_filter :verify_login, :only => [:index, :edit, :new, :list]

  def init_layout
    @title = 'Categories'
    @cat_expanded = true
  end

  def index
    @categories = Category.find(:all, :order => 'modified_at DESC, created_at DESC', :limit => '10')
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
    @category.languages << Language.new
    @subtitle = 'Edit ' + @category.title
  end

  def update
    @cat = Category.find params[:id]
    @cat.modified_at = Time.now

    # Fix language bug
    if params[:category][:languages_attributes]['0'][:language].blank? || params[:category][:languages_attributes]['0'][:words].blank?
      params[:category].delete :languages_attributes
      params[:category][:language_ids] = [] 
    end

    # Remove nested attribute because I did it myself
    params[:category].delete :books_attributes if params[:category].has_key? :books_attributes

    if @cat.update_attributes params[:category]
      flash[:notice] = 'Category succesfully updated!'
      redirect_to :action => 'add_books', :id => params[:id]
    else
      flash[:error] =  'Problem updating Category.'
      render 'edit'
    end
  end

  def attach
    @cat = Category.find params[:id]
    @cat.modified_at = Time.now

    if @cat.update_attributes params[:category]
      flash[:notice] = 'Books succcesfully added'
      redirect_to :action => 'index'
    else
      flash[:error] =  'Problem adding books.'
      render 'add_books'
    end
  end

  def create
    if params[:category][:languages_attributes][0][:language].blank? || params[:category][:languages_attributes][0][:words].blank?
      params[:category].delete :languages_attributes
      params[:category][:language_ids] = [] 
    end
    @category = Category.new params[:category]

    if @category.save
      flash[:notice] = 'Category succesfully created!'
      redirect_to :action => 'add_books', :id => params[:id]
    else
      render 'new'
    end
  end

  def add_books
    @category = Category.find params[:id], :include => :books
    @subtitle = 'Attach Books'
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

  def sub_search
    respond_to do |format|
      format.js do 
        cats = Subcategory.find(:all, :conditions => ['title LIKE ?', '%' + params[:term] + '%'], :limit => 5, :order => 'title ASC')
        options = cats.collect {|cat| {:label => cat.title, :value => '', :id => cat.id}}
        options = [{:label => 'No Matches', :value => '', :id => ''}] if cats.empty?
        render :text => options.to_json
      end
    end
  end
end
