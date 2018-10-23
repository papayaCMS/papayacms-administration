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
      icon : 'pics/icons/16x16/items/image.png',
      dialogUrl : 'script/controls/image.php',
      dialogWidth : '604px',
      dialogHeight : '394px',
      rpcUrl : 'xml-api?rpc[cmd]=image_data&rpc[thumbnail]=1&rpc[image_conf]='
    },

    updateField : function(mediaItem) {
      this.field.val(
        mediaItem.id + ',' +
        mediaItem.width + ',' +
        mediaItem.height + ',' +
        mediaItem.resizeMode
      );
      this.update();
    }
  };

  $.papayaDialogFieldImageResized = function() {
    return $.extend(true, $.papayaDialogFieldImage(), field);
  };

  $.fn.papayaDialogFieldImageResized = function(settings) {
    this.each(
      function() {
        $.papayaDialogFieldImageResized().setUp(this, settings).update();
      }
    );
    return this;
  };
})(jQuery);
