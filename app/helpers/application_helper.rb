# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def flash_messages
    flash_string = ''
    APP[:flash_names].each do |name|
      flash_string += "<div class=\"#{name}\">#{flash[name]}</div>" if flash[name]
    end       
    flash_string
  end

  def sidebar_menu alpha, menu_categories
    menu = '<div id="navmenu">'
    alpha.each do |letter|
      if menu_categories[letter]
        menu +=
            "<div id=\"menu_parent#{letter}\" class=\"menu_parent\">#{letter.upcase}</div>
            <ul id=\"menu_child#{letter}\" class=\"menu_child\">"
            menu_categories[letter].length.times do |index|
              category = @menu_categories[letter][index]
              menu +=
                "<li><a href=\"/categories/#{category.id}\"\">#{category.title}</a></li>"
            end
          menu +=
            '</ul>'
      end
    end
    menu += '</div>'
    return menu
  end

end
