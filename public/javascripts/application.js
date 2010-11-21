// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function(){

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
});
