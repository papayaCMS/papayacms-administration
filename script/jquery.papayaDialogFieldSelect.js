/*
 * papaya CMS
 *
 * @copyright 2000-2018 by papayaCMS project - All rights reserved.
 * @link http://www.papaya-cms.com/
 * @license http://www.gnu.org/licenses/old-licenses/gpl-2.0.html GNU General Public License, version 2
 *
 *  You can redistribute and/or modify this script under the terms of the GNU General Public
 *  License (GPL) version 2, provided that the copyright and license notes, including these
 *  lines, remain unmodified. papaya is distributed in the hope that it will be useful, but
 *  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 *  FOR A PARTICULAR PURPOSE.
 */

/**
* papaya Dialog Field Page
*
* Input field with page id popup
*/
(function($) {

  var field = {

    settings: {
      icon: 'pics/icons/16x16/items/page.png',
      url: 'popup/page'
    },

    template: '<table class="dialogField">' +
      '<tr>' +
      '<td class="action">' +
      '<input class="filter dialogInput dialogSearch" type="text"/>' +
      '</td>' +
      '<td class="field"></td>' +
      '</tr>' +
      '</table>',

    items : null,
    groups : null,

    onActionTrigger: function (event) {
      var that = this;
      event.preventDefault();
      var expression = new RegExp(
        this.wrapper.find('.action input').val().replace("[", "\\[").replace("]", "\\]"),
        'i'
      );
      var currentValue = this.field.val();
      if (this.items == null) {
        this.items = [];
        this.field.find('option').each(
          function () {
            that.items.push(
              {
                item : this,
                parent : $(this).parent(),
                previous : $(this).prev()
              }
            );
          }
        );
        this.groups = [];
        this.field.find('optgroup').each(
          function () {
            that.groups.push(
              {
                group : this,
                parent : $(this).parent(),
                previous : $(this).prev()
              }
            );
          }
        )
      }

      $.each(
        this.items,
        function () {
          var item = $(this.item);
          var label = item.text();
          if (label.match(expression)) {
            item.appendTo(this.parent);
          } else {
            item.detach();
          }
        }
      );
      $.each(
        this.groups,
        function () {
          var group = $(this.group);
          if (group.find('option').length > 0) {
            group.appendTo(this.parent);
          } else {
            group.detach();
          }
        }
      );
      this.field.find('optgroup').sortElements(
        function(a, b) {
          return $(a).attr('label') > $(b).attr('label') ? 1 : -1;
        }
      );
      this.field.find('option').sortElements(
        function(a, b) {
          return $(a).text() > $(b).text() ? 1 : -1;
        }
      );
      this.update(currentValue);
    },

    update: function (currentValue) {
      this.field.find('option').each(
        function (index) {
          var item = $(this);
          if (index % 2) {
            item.removeClass('odd').addClass('even');
          } else {
            item.removeClass('even').addClass('odd');
          }
        }
      );
      if ((!currentValue) ||
          this.field.find('option[value="' + currentValue + '"]').length < 1) {
        if (this.field.find('option:selected').length > 0) {
          currentValue = this.field.find('option:selected').eq(0).val();
        } else {
          currentValue = this.field.find('option').eq(0).val();
        }
      }
      this.field.val(currentValue);
    }
  };

  $.papayaDialogFieldSelect = function() {
    return $.extend(true, $.papayaDialogField(), field);
  };

  $.fn.papayaDialogFieldSelect = function(settings) {
    this.each(
      function() {
        $.papayaDialogFieldSelect().setUp(this, settings).update();
      }
    );
    return this;
  };
})(jQuery);
