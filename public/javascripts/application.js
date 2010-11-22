// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function(){

  // Set up the autocomplete for categories that redirect. Also set up the
  // button to remove the redirect
  $('input.ac_redirect').autocomplete({
      source: '/admin/categories/search',
      select: function(event, ui) {
          text = ui.item.label;
          $('span#redirect').html(text);
          $('div.ui-state-highlight').slideDown();
          $("input[name='category\\[redirect_id\\]']").val(ui.item.id);
      }
    });

  $('div.redirect a.close').click(function() {
        $('div.ui-state-highlight').slideUp();
        $("input[name='category\\[redirect_id\\]']").val('');
    });

  // Set up autocomplete to add books
  $('input.ac_sources').autocomplete({
      source: '/admin/books/search',
      select: function(event, ui) {
          // Check to make sure there are matches
          if (ui.item.label == 'No Matches')
            return;

          // First remove the hidden empty array if exists
          empty_indicator = $('#book_empty');
          if (empty_indicator.length != 0)
            empty_indicator.remove();

          // Then add the hidden field with the id of the book
          hidden_field = '<input type="hidden" name="category[book_ids][]" id="book_' + ui.item.id + '" value="' + ui.item.id + '" />';
          $("input.ac_sources").after(hidden_field);

          // Set up item to be added.
          li =
            '<div>' + 
              '<span class="ui-icon ui-icon-radio-on bullet"></span>' +
              '<span>' + ui.item.label + '</span>' + 
              '<a href="javascript:void(0)" id="book_link_' + ui.item.id + '" class="close"><span class="ui-icon ui-icon-close"></span></a>' + 
            '</div>';

          // Then add the name of the book to the appropriate list of books
          if (ui.item.modern == 'true')
            $('div.modern_sources').append(li);
          else
            $('div.bibliography').append(li);

          // Finally show the div with the list if its not shown
          if ($('div.ui-state-highlight').css('display') == 'none');
            $('div.ui-state-highlight').slideDown();
      }
    });

  // Handler for when user clicks x for a list item in the bibliography div
  $('div.bibliography a.close').click(function(event) {
      if (event.target.nodeName.toLowerCase() == 'span')
      {
        // Get 'a' tag
        link = $(event.target).parent()

        // Get the Book id
        link_id = link.attr('id');
        book_id = link_id.split('_')[2];

        // Remove the hidden input field and the div containing the list element
        $('#book_' + book_id).remove();
        link.parent().remove();
      }
      else
        alert(event.target.nodeName.toLowerCase());

      // Conceal yellow divs if no list items
      if ($('div.bibliography').children('div').length == 0)
        $('div.bibliography').slideUp();

      // Insert hidden input field with empty array if both divs are empty.
      if ($('div.bibliography').children('div').length == 0 && $('div.modern_sources').children('div').length == 0)
      {
          hidden_field = '<input type="hidden" name="category[book_ids][]" id="book_empty" value="" />';
          $("input.ac_sources").after(hidden_field);
      }
    });

  // Handler for when user clicks x for a list item in the modern sources div
  $('div.modern_sources a.close').click(function(event) {
      if (event.target.nodeName.toLowerCase() == 'span')
      {
        // Get 'a' tag
        link = $(event.target).parent()

        // Get the Book id
        link_id = link.attr('id');
        book_id = link_id.split('_')[2];

        // Remove the hidden input field, the div containing the list element
        $('#book_' + book_id).remove();
        link.parent().remove();
      }
      else
        alert(event.target.nodeName.toLowerCase());

      if ($('div.modern_sources').children('div').length == 0)
        $('div.modern_sources').slideUp();
    });


  // Starts js for adding languages to categories on /admin/categories/new and /admin/categories/(id number)/edit
  var i = 1;

  plus = '<a href="javascript:void(0)" id="add_language"><span class="add_language"></span></a>';
  $('fieldset.languages').children('div').last().children('p').append(plus);
  

  $('a#add_language').click(function() {
        another_language = 
          '<div class="language">' +
            '<p><label>Language:</label><input name="category[languages_attributes][' + i + '][language]" class="text-long" /></p>' +
          '</div>' +
          '<div class="words">' + 
            '<p><label>Words:</label><input name="category[languages_attributes][' + i + '][words]" class="text-long" />' + 
            '</p>' +
          '</div>';        
        plus_sign = $('a#add_language').detach();
        $('fieldset.languages').append(another_language);
        $('fieldset.languages').children().last().children('p').append(plus_sign);
        i++;
    });
});
