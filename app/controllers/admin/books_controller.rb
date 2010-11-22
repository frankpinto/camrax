class Admin::BooksController < ApplicationController
  layout 'admin'
  before_filter :verify_login, :only => [:index, :edit, :new, :list]
  before_filter :init_layout

  def init_layout
    @title = 'Books'
    @books_expanded = true
  end  

  def index
    @books = Book.find(:all, :order => 'created_at ASC', :limit => '10')
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
    @book = Book.new params[:book]
    if @book.save
      flash[:notice] = "Book saved successfully"
      redirect_to :index
    else
      flash[:notice] = "Error in saving book."
      render 'new'
    end
  end

  def update
    @book = Book.new params[:book]
    if @book.save
      flash[:notice] = "Book saved successfully"
      redirect_to :index
    else
      flash[:notice] = "Error in saving book."
      render 'new'
    end
  end

  def search
    respond_to do |format|
      format.js do 
        books = Book.find(:all, :conditions => ['full_title LIKE ? OR short_title LIKE ?', '%' + params[:term] + '%', '%' + params[:term] + '%'], :limit => 5, :order => 'short_title ASC', :include => :authors)
        options = books.collect {|book| {:label => book.short_title, :value => '', :id => book.id}}
        options = [{:label => 'No Matches', :value => '', :id => ''}] if books.empty?
        render :text => options.to_json
      end
    end    
  end
end
