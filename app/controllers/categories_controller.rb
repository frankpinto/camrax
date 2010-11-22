class CategoriesController < ApplicationController
  before_filter :menu
  
  def index
  end

  def show
    @category = Category.find params[:id], :include => :redirect
    if !@category.redirect.blank?
      redirect_to :action => 'show', :id => @category.redirect.id
    end
    @width = '33%' #@category.modern ? '33%' : '50%'
  end

  def menu
    cats = Category.find(:all, :order => 'title ASC')
    @menu_categories = {}
    @alphabet = ('a'..'z').to_a
    cats.each do |category|
      @menu_categories[category.title[0...1].downcase] = [] if @menu_categories[category.title[0...1].downcase].nil?
      @menu_categories[category.title[0...1].downcase] << category
    end
  end  
end
