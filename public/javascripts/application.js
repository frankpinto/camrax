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
  $('input.ac_bibliography').autocomplete({
      source: '/admin/books/search',
      select: function(event, ui) {
          if (ui.item.label == 'No Matches')
            return;
          // First add the name of the book to the list of books
          li =
            '<div>' + 
              '<span class="ui-icon ui-icon-radio-on bullet"></span>' +
              '<span>' + ui.item.label + '</span>' + 
              '<a href="javascript:void(0)" id="book_link_' + ui.item.id + '" class="close"><span class="ui-icon ui-icon-close"></span></a>' + 
            '</div>';
          $('div.bibliography').append(li);

          // Then add the hidden field with the id of the book
          hidden_field = '<input type="hidden" name="category[book_ids][]" id="book_' + ui.item.id + '" value="' + ui.item.id + '" />';
          $("input.ac_bibliography").after(hidden_field);

          // Finally show the div with the list if its not shown
          if ($('div.ui-state-highlight').css('display') == 'none');
            $('div.ui-state-highlight').slideDown();
      }
    });

  $('div.bibliography a.close').click(function(event) {
      alert(event.target.val());
      //$('book_1').remove();
      //if ($('fieldset p').children().length() == 1)
        //$('div.ui-state-highlight').slideUp();
    });

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
        //$("input[name='category\\[redirect_id\\]']").val('');
    });
});
