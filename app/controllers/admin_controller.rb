require 'yaml'

class AdminController < ApplicationController
  def index
    if session[:logged_in]
      redirect_to :controller => 'admin/categories'
    end
  end

  def login
    if params[:username] == 'admin' && params[:password] == 'camrax'
      session[:logged_in] = true
      flash[:notice] = "Successfully logged in."
      redirect_to :action => 'index'
    elsif params.has_key? :username
      flash[:error] = "Incorrect Username and Password"
      redirect_to :action => 'index'
    else
      redirect_to :action => 'index'
    end
  end

  def logout
    session[:logged_in] = false
    redirect_to :action => 'index'
  end

  def preload
    Dir.new(RAILS_ROOT + '/yamls/').entries.each do |file|
      unless file == '.' || file == '..' || file == 'All_Categories.yml'
        category = Category.find_by_title file.split('.')[0]
        raw_data = File.read(RAILS_ROOT + '/yamls/' + file)
        collection = YAML.load(raw_data)
        collection.each do |entry|
          author_name = entry['author'].split(' ')
          author = Author.create :first_name => author_name[0], :last_name => author_name[1]
          entry['books'].each do |book|
            book_to_add = Book.create :short_title => book['title'], :date => book['Publishing Year'], :brief_description => book['description'], :publication_location => book['Publishing Location'], :publisher => book['Publisher'], :author_ids => [author.id]
            category.books << book_to_add
          end
        end
      end
    end
    redirect_to '/'
  end
end
