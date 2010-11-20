class Admin::BooksController < ApplicationController
  layout 'admin'
  before_filter :verify_login, :only => [:index, :edit, :new, :list]
  before_filter :init_layout

  def init_layout
    @title = 'Books'
    @books_expanded = true
  end  

  def index
    
  end

  def list
    
  end

  def new
    @subtitle = 'Add a Book'
    @book = Book.new
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
end
