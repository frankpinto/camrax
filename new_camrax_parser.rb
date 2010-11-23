require 'rubygems'
require 'hpricot'
require 'htmlentities'
require 'open-uri'
require 'yaml'
require 'ya2yaml'
require 'rchardet'
require 'iconv'

class CamraxParser
  attr_accessor :bibliography
  attr_accessor :collection
  attr_accessor :misbehaving
  attr_accessor :category_urls
  attr_accessor :category
  attr_accessor :url
  $KCODE = 'UTF8'

  def initialize
    # Format will be: [
    # {'author' => '', 'books' => [
    # {'title' => '', 'extras' => ''},
    # {'title' => '', 'extras' => '', description' => ''}
    # ]},
    # {'author' => '', 'books' => [
    # {'title' => '', 'extras' => ''},
    # {'title' => '', 'extras' => ''}
    # ]}, etc.]
    self.category_urls = []

    # To hold the whole web page
    self.bibliography = ''

    # To collect which lines didn't parse correctly
    self.misbehaving = []

    if ARGV.length > 1
      self.category = ARGV[0]
      self.url = ARGV[1]
    elsif ARGV.length == 1
      if ARGV[0] == 'preload'
        self.category_urls = [['Proverbs', 'http://www.camrax.com/symbol/proverbbooks.php4'], ['Allegories','http://www.camrax.com/symbol/allegorybooks.php4'], ['Talismans','http://www.camrax.com/symbol/talismanbooks.php4'], ['Apophthegms', 'http://www.camrax.com/symbol/apophthegmbooks.php4'], ['Fables', 'http://www.camrax.com/symbol/fablesbooks.php4'], ['Apparatus', 'http://www.camrax.com/symbol/apparatusbooks.php4'], ['Arms','http://www.camrax.com/symbol/armsbooks.php4'], ['Divinations', 'http://www.camrax.com/symbol/divinationbooks.php4']]
      end
    else
      done = false
      while (self.category_urls.empty? || done != true)
        puts 'Please enter the category you will be entering books for: '
        self.category = gets.strip
        puts 'Please enter the URL you would like to scrape for books: '
        self.url = gets.strip
        if self.url.empty? || self.category.empty?
          done = true
        else
          self.category_urls << [self.category, self.url]
        end
      end
    end
  end

  def run
    self.category_urls.each do |category, url|
      self.collection = []
      self.bibliography = open(url) do |f| 
        page = f.read
        encoding = CharDet.detect(page)['encoding']
        converted_page = Iconv.conv(encoding + '//IGNORE', 'utf-8', page)
        Hpricot(converted_page, :fixup_tags => true)
      end
      # Get start div tag
      start_div = (bibliography/'div[@class="titlediv"]')[0].next
      start_div = start_div.next while start_div.class == Hpricot::Text

      # Get start p tag
      p_tags = start_div/'p'

      # Now iterate through and start pulling data...
      p_tags.each do |p|
        # Declare variables for safety's sake
        author = nil
        title = nil
        extras = nil
        publisher = nil
        publishing_location = nil
        publishing_year = nil

        if p['class'] == 'description' || p['class'] == 'descriptionnospace'
          # If the paragraphs class matches those above then it is the
          # description of the book that was just added. Thus, grab the last book
          # added and add a description to it.
          collection.last['books'].last['description'] = p.inner_html.strip
        else
          # New title. Titles are always italicized using either em or italic
          title_tag = p/'em'
          title_tag = p/'i' if title_tag.empty?
          title = title_tag.inner_html.strip

          if p.inner_html[0].chr == '-' || p.inner_html[0..4] == '<em>-'
            # If the p tags contents start with a dash then the book belongs to
            # the author that was just added.

            # Parse the publishing informating from the line
            if p.inner_html =~ /-+#{title_tag.to_html}\s*([\w,:\.\s]+)/
              extras = $1.strip
              if extras =~ /\s*(.+?):\s*(.+?)\s*(\d+)/
                publishing_location = $1.strip
                publisher = $2.strip.chomp(',')
                publishing_year = $3
              elsif extras =~ /\s*(.+?)[:,]\s*(\d+)/
                publishing_location = $1.strip
                publishing_year = $2
                publisher = 'Unknown'
              else
                misbehaving.push extras
              end
            end

            # Grab the last author's books and push another books onto the end
            collection.last['books'].push({'title' => title, 'Publisher' => publisher, 'Publishing Location' => publishing_location, 'Publishing Year' => publishing_year})
          else
            # New author. Author's name is always either in strong tags or bold tags
            author_tag = p/'strong'
            author_tag = p/'b' if author_tag.empty?
            author = author_tag.inner_html

            # Parse the specific information from the line
            if (p.inner_html =~ /#{author_tag.to_html},?\s*([\w;&]*)\s*#{title_tag.to_html}\s*([\w\d,:\.\s]+)/)
              # Add authors first name if he has one
              author = $1 + ' ' + author if !$1.empty?

              # Parse publishing information
              extras = $2.strip
              if extras =~ /\s*(.+?):\s*(.*?)\s*(\d+)/
                publishing_location = $1.strip
                publisher = $2.strip.chomp(',')
                publishing_year = $3
              elsif extras =~ /\s*(.+?)[:,]\s*(\d+)/
                publishing_location = $1.strip
                publishing_year = $2
                publisher = 'Unknown'
              else
                misbehaving.push extras
              end
            end

            # At this point the authors not supposed to be empty. If it is then
            # this is a misbehaving line so add it to the array. Otherwise, the
            # data is most likely valid so create a new author.
            if author.empty?
              misbehaving.push p
            else
              collection.push({'author' => author, 'books' => [{'title' => title, 'Publisher' => publisher, 'Publishing Location' => publishing_location, 'Publishing Year' => publishing_year}]})
            end

          end
        end
      end

      # Write collection of books in a nice format to a file
      file = File.open('C:\Users\Frank Pinto\Documents\Spruce\camrax\yamls\\' + category + '.yml', 'w')
      file.puts collection.ya2yaml
      file.close
    end

    # Write all categories in a nice format to a file
    file   = File.open('C:\Users\Frank Pinto\Documents\Spruce\camrax\yamls\All_Categories.yml', File::WRONLY|File::APPEND|File::CREAT)
    file.puts self.category_urls.ya2yaml
    file.close
  end
end

# Run it!
p = CamraxParser.new
p.run
