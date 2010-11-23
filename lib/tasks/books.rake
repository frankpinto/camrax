directory 'yamls'

desc "Grab Books from URLs preloaded in script"
task :scrape_books do
  sh 'ruby new_camrax_parser.rb preload'
  puts 'Files are now in RAILS_ROOT/yaml/'
end

desc "Push Books to database"
task :push_books => [:environment, 'yamls'] do
  Dir.new(RAILS_ROOT + '/yamls/').entries.each do |file|
    unless file == '.' || file == '..' || file == 'All_Categories.yml'
      category = Category.find_by_title file.split('.')[0]
      raw_data = File.read(RAILS_ROOT + '/yamls/' + file)
      collection = YAML.load(raw_data)
      collection.each do |entry|
        author_name = entry['author'].strip.split(/\s+/)
        author = Author.create :first_name => author_name[0], :last_name => author_name[1]
        entry['books'].each do |book|
          book['title'] = book['title'].strip if book['title']
          book['Publishing Year'] = book['Publishing Year'].strip if book['Publishing Year']
          book['description'] = book['description'].strip if book['description']
          book['Publishing Location'] = book['Publishing Location'].strip if book['Publishing Location']
          book['Publisher'] = book['Publisher'].strip if book['Publisher']
          book_to_add = Book.create :short_title => book['title'], :date => book['Publishing Year'], :brief_description => book['description'], :publication_location => book['Publishing Location'], :publisher => book['Publisher'], :author_ids => [author.id]
          category.books << book_to_add
        end
      end
    end
  end
end
