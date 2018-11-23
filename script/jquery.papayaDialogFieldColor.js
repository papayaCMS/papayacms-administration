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

    settings : {
      icon : 'icon.actions.color-select?size=16',
      url : 'popup/color',
      width : '310',
      height : '300'
    },

    onActionTrigger : function(event) {
      var that = this;
      event.preventDefault();
      $.papayaPopIn(
        {
          url : this.settings.url,
          width : this.settings.width,
          height : this.settings.height,
          context : this.field.val()
        }
      )
      .open()
      .done(
        function (color) {
          if (color) {
            that.field.val(color);
          }
        }
      );
    }
  };

  $.papayaDialogFieldColor = function() {
    return $.extend(true, $.papayaDialogField(), field);
  };

  $.fn.papayaDialogFieldColor = function(settings) {
    this.each(
      function() {
        var instance = $.papayaDialogFieldColor();
        instance.setUp(this, settings);
      }
    );
    return this;
  };
})(jQuery);
