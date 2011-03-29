require 'rubygems'
require 'hpricot'
require 'htmlentities'
require 'open-uri'
require 'yaml'

class CamraxParser
  attr_accessor :bibliography
  attr_accessor :collection
  attr_accessor :misbehaving

  def initialize
    self.collection = []

    # To hold the whole web page
    self.bibliography = ''

    # To collect which lines didn't parse correctly
    self.misbehaving = []
  end

  def run
    self.bibliography = open('http://www.camrax.com/symbol/emblembooks.php4') {|f| Hpricot(f, :fixup_tags => true) }
    # Get all paragraph tags
    p_tags = bibliography/'p'

    # Get the index of the first paragraph with a book
    index = nil
    p_tags.each_with_index do |p, i|
      if p['align'] == 'center'
        index = i
      end
    end

    # Delete p tags up until the one we need
    p_tags[0..index] = nil


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
        collection.last['books'].last['description'] = p.inner_html
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
    file = File.open('C:\Users\Frank Pinto\Documents\Spruce\formatted.yml', 'w')
    file.puts collection.to_yaml
    file.close

  end
end

# Run it!
p = CamraxParser.new
p.run
