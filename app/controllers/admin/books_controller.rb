class Admin::BooksController < ApplicationController
  layout 'admin'
  before_filter :verify_login, :only => [:index, :edit, :new, :list]
  before_filter :init_layout

  def init_layout
    @title = 'Books'
    @books_expanded = true
  end  

  def index
    @books = Book.find(:all, :order => 'modified_at DESC, created_at DESC', :limit => '10')
    @book = Book.new
    @subtitle = 'Dashboard'
  end

  def list
    @books = Book.find(:all, :order => 'short_title ASC')
    @subtitle = 'View All'
    render :partial => 'list', :layout => 'admin'    
  end

  def new
    @subtitle = 'Add a Book'
    @book = Book.new
  end

  def create
    # Either id or create new both not both
    if !params[:book][:category_id].blank? && params[:book].has_key?(:category_title)
      params[:book].delete(:category_title) 
    elsif params[:book].has_key? :category_id
      params[:book].delete(:category_id)
    end
    if (!params[:book][:subcategory_id].blank? && params[:book].has_key?(:subcategory_title))
      params[:book].delete(:subcategory_title) 
    elsif params[:book].has_key? :subcategory_id
      params[:book].delete(:subcategory_id) 
    end

    @book = Book.new params[:book]
    if @book.save
      flash[:notice] = "Book saved successfully"
      redirect_to '/admin/books'
    else
      flash[:error] = "Error in saving book."
      render 'new'
    end
  end

  def edit
    @book = Book.find params[:id]
    @subtitle = 'Edit ' + @book.short_title    
  end

  def update
    # Either id or create new both not both
    if !params[:book][:category_id].blank? && params[:book].has_key?(:category_title)
      params[:book].delete(:category_title) 
    elsif params[:book].has_key? :category_id
      params[:book].delete(:category_id)
    end
    if (!params[:book][:subcategory_id].blank? && params[:book].has_key?(:subcategory_title))
      params[:book].delete(:subcategory_title) 
    elsif params[:book].has_key? :subcategory_id
      params[:book].delete(:subcategory_id) 
    end

    @book = Book.find params[:id]
    @book.modified_at = Time.now
    
    if @book.save
      flash[:notice] = "Book saved successfully"
      redirect_to '/admin/books'
    else
      flash[:error] = "Error in saving book."
      render 'edit'
    end
  end

  def search
    respond_to do |format|
      # Only do something if javascript was requested (for now)
      format.js do 
        # Get books that match autocomplete terms
        books = Book.find(:all, :conditions => ['full_title LIKE ? OR short_title LIKE ?', '%' + params[:term] + '%', '%' + params[:term] + '%'], :limit => 5, :order => 'short_title ASC', :include => :authors)

        # Turn into form that jquery autocomplete likes
        options = books.collect {|book| {:label => book.short_title, :value => '', :id => book.id, :modern => book.modern}}
        options = [{:label => 'No Matches', :value => '', :id => ''}] if books.empty?
        render :text => options.to_json
      end
    end    
  end
end
