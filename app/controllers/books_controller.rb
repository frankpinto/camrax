class BooksController < ApplicationController
  before_filter :menu

  def menu
    cats = Category.find(:all, :order => 'title ASC')
    @menu_categories = {}
    @alphabet = ('a'..'z').to_a
    cats.each do |category|
      @menu_categories[category.title[0...1].downcase] = [] if @menu_categories[category.title[0...1].downcase].nil?
      @menu_categories[category.title[0...1].downcase] << category
    end
  end  
  
  def index
    @category = Category.find params[:category_id], :include => :books
    @books = @category.books
    @width = '33%' #@category.modern ? '33%' : '50%'    
    render 'index'
  end
end
