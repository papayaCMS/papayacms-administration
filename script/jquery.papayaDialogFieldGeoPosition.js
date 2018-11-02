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
      icon : 'pics/icons/16x16/items/publication.png',
      url : 'popup/googlemaps',
      width : '310',
      height : '410'
    },

    onActionTrigger : function(event) {
      var that = this;
      event.preventDefault();
      $.papayaPopIn(
        {
          url : this.settings.url,
          width : this.settings.width,
          height : this.settings.height
        }
      )
      .open()
      .done(
        function (latitude, longuitude) {
          if (latitude && longuitude) {
            that.field.val(latitude+","+longuitude);
          }
        }
      );
    }
  };

  $.papayaDialogFieldGeoPosition = function() {
    return $.extend(true, $.papayaDialogField(), field);
  };

  $.fn.papayaDialogFieldGeoPosition = function(settings) {
    this.each(
      function() {
        var instance = $.papayaDialogFieldGeoPosition();
        instance.setUp(this, settings);
      }
    );
    return this;
  };
})(jQuery);
