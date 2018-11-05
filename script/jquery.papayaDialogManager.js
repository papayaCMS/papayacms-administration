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
* papaya Dialog Manager
*
* Activates some shortcut, changes handling for the form elements
*
* ctrl+s submits the currently focused form
*
* if a field is changed in a "protected form", the page is marked and unload
* will bring up an confirmation dialog
*/
(function($) {

  var stringify = {
    shortcut : function(event) {
      if (typeof event )
      var result = '';
      if (event.ctrlKey || event.metaKey) {
        result += 'ctrl';
      }
      if (event.altKey) {
        result += '+alt';
      }
      if (event.shiftKey) {
        result += '+shift';
      }
      if (event.keyCode) {
        result += '+' + String.fromCharCode(event.keyCode).toLowerCase();
      }
      return result.replace(/^\+/, '');
    }
  };

  var shortcuts = {

    keydown : {},

    on : function(shortcut, callback) {
      this.keydown[shortcut] = callback;
    },

    has : function(shortcutOrEvent) {
      return (typeof this.keydown[stringify.shortcut(shortcutOrEvent)] !== 'undefined');
    },

    handle : function(event) {
      var shortcut = stringify.shortcut(event);
      if (this.keydown[shortcut]) {
        this.keydown[shortcut](event);
        return true;
      }
      return false;
    }
  };

  var manager = {

    shortcuts : shortcuts,

    changed : false,

    settings : {
      message : 'Unsaved changes, leave without saving?'
    },

    setUp : function(settings) {
      this.settings = $.extend(this.settings, settings);
      return this.setUpProtector().setUpShortcuts();
    },

    setUpProtector : function() {
      var that = this;
      var forms = $('form.dialogProtectChanges');
      if (forms.length > 0) {
        forms.find('input,select,textarea').on(
          'change',
          function () {
            $(this).parents('form').addClass('dialogChanged');
            that.changed = true;
          }
        );
        forms.on(
          'submit',
          function () {
            $(window).unbind('beforeunload');
          }
        );
        $(window).on(
          'beforeunload',
          function (event) {
            event.stopImmediatePropagation();
            if (that.changed) {
              return that.settings.message;
            }
            return null;
          }
        );
      }
      return this;
    },

    setUpShortcuts : function() {
      var that = this;
      this.shortcuts.on(
        'ctrl+s',
        function (event) {
          var target = $((event.target) ? event.target : event.srcElement);
          if (target.not('form')) {
            target = target.parents('form');
          }
          if (target.is('form')) {
            target.submit();
          }
        }
      );
      $(document).on(
        'keyup',
        function (event) {
          if (that.shortcuts.handle(event)) {
            event.preventDefault();
            return false;
          }
          return true;
        }
      );
      $(document).on(
        'keypress keydown',
        function (event) {
          if (that.shortcuts.has(event)) {
            event.preventDefault();
            return false;
          }
          return true;
        }
      );
      return this;
    }
  };

  $.papayaDialogManager = function() {
    return manager;
  };
})(jQuery);
