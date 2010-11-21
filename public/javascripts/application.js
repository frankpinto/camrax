// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function(){
    var i = 1;

  $('input.autocomplete').autocomplete({
      source: '/admin/categories/search',
      select: function(event, ui) {
          text = ui.item.label;
          $('span#redirect').html(text);
          $('div.ui-state-highlight').slideDown();
          $("input[name='category\\[redirect_id\\]']").val(ui.item.id);
      }
    });

  $('a.close').click(function() {
        $('div.ui-state-highlight').slideUp();
        $("input[name='category\\[redirect_id\\]']").val('');
    });

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
