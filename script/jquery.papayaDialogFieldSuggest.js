/**
* papaya Dialog Field Suggest
*
* Input field with auto suggest
*/
(function($) {

  var field = {

    settings : {
      url : ''
    },

    template :
      '<table class="dialogField">'+
        '<tr>'+
          '<td class="field"></td>'+
        '</tr>'+
        '<tr class="suggest"><td><ul></ul></td></tr>'+
      '</table>',

    onChangeTrigger : function(event) {
      event.preventDefault();
      this.update();
    },

    update : function() {
      // initialization and declaration of vars
      var textValue = this.field.val();
      var suggestionList = [];
      var that = this;

      // create a deferred object to make an ajax call.
      var defer = $.ajax(
        {
          type: "GET",
          url: this.settings.url,
          dataType: "xml"
        }
      );

      defer.done(
        function (xml) {
          // Add the suggestions, that match the input to the output array
          $(xml).find('item').each(
            function () {
              var suggest = $(this).text();
              if (suggest.match(textValue)) {
                suggestionList.push(suggest);
              }
            }
          );
          // delete old suggestions from the DOM before appending new suggestions
          var list = that.wrapper.find('.suggest ul');
          if (that.field.is(':focus')) {
            list.empty();
            // Append each suggestion item as link to the DOM
            if (textValue.length > 0 && suggestionList.length > 0) {
              for (var i = 0; i < suggestionList.length; i++) {
                list.append('<li><a href="#"/></li>').find('li:last a').text(suggestionList[i]);
              }
            }
            // insert the clicked suggestion into the input field
            $('.suggest a').click(
              function(e) {
                e.preventDefault();
                var index = $(this).parent().index();
                that.field.val(suggestionList[index]);
                that.wrapper.find('.suggest ul').hide();
              }
            );
            list.show();
          }
        }
      );
    }
  };

  $.papayaDialogFieldSuggest = function() {
    return $.extend(true, $.papayaDialogField(), field);
  };

  $.fn.papayaDialogFieldSuggest = function(settings) {
    this.each(
      function() {
        var instance = $.papayaDialogFieldSuggest();
        instance.setUp(this, $.extend(true, {}, settings, $(this).data('suggest'))).update();
      }
    );
    return this;
  };
})(jQuery);