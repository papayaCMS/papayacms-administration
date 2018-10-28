<?php
/**
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
* incusion of base or additional libraries
*/
require_once(dirname(__FILE__).'/inc.controls.php');
?>
<!DOCTYPE HTML>
<html>
  <head>
  <title><?php echo _gt('Select page');?></title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8">
    <link rel="stylesheet" type="text/css" href="../../styles/css">
    <link rel="stylesheet" type="text/css" href="../../styles/css.popup">
  </head>
  <body id="popup">
    <div class="title">
      <div class="artworkOverlay">
        <svg width="100%" height="100%" xmlns="http://www.w3.org/2000/svg">
          <defs>
            <pattern id="dots" width="4" height="4" patternUnits="userSpaceOnUse">
              <rect x="2" y="2" width="1" height="1" fill="#F00"> </rect>
            </pattern>
          </defs>
          <rect width="100%" height="100%" fill="url(#dots)"> </rect>
        </svg>
      </div>
      <h1 id="popupTitle"><?php echo _gt('Select page');?></h1>
    </div>
    <div id="workarea">
      <div id="divLinkModePage">
        <input type="text" class="text" id="editPage" disabled="disabled" style="width: 100%"/>
      </div>
      <div class="panel">
        <div class="panelBody" style="height: 350px; overflow: auto;">
          <table class="listview">
            <tbody data-plugin="pagetree">
            </tbody>
          </table>
        </div>
      </div>
      <div class="popupButtonsArea" style="text-align: right; white-space: nowrap;">
        <input type="button" value="<?php echo _gt('Ok');?>" class="dialogButton"
          papayaLang="DlgBtnOk" data-action="resolve"/>
        <input type="button" value="<?php echo _gt('Cancel')?>" class="dialogButton"
          papayaLang="DlgBtnCancel" data-action="reject"/>
      </div>
    </div>
    <div class="footer">
      <div class="artworkOverlay">
        <svg width="100%" height="100%" xmlns="http://www.w3.org/2000/svg">
          <defs>
            <pattern id="dots" width="4" height="4" patternUnits="userSpaceOnUse">
              <rect x="2" y="2" width="1" height="1" fill="#F00"> </rect>
            </pattern>
          </defs>
          <rect width="100%" height="100%" fill="url(#dots)"> </rect>
        </svg>
      </div>
    </div>
    <script type="text/javascript" src="../../script/jquery/js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="../../script/jquery.papayaPageTree.js"></script>
    <script type="text/javascript">
      var papayaPageId = 0;
      var papayaContext = null;

      jQuery(document).ready(
        function() {
          jQuery(window).on(
            'keyup',
            function (event) {
              if (event.keyCode == 27) {
                jQuery('input[data-action=reject]').click();
              }
            }
          );
          jQuery('input[data-action=resolve]').click(
            function () {
              if (window.papayaContext) {
                window.papayaContext.defer.resolve(papayaPageId);
              } else {
                linkedObject.value = papayaPageId;
              }
              if (!window.frameElement) {
                window.close();
              }
            }
          );
          jQuery('input[data-action=reject]').click(
            function () {
              if (window.papayaContext) {
                window.papayaContext.defer.reject();
              }
              if (!window.frameElement) {
                window.close();
              }
            }
          );
          jQuery('[data-plugin~=pagetree]').papayaPageTree(
            {
              onSelect : function(pageId, pageTitle) {
                papayaPageId = pageId;
                $('#editPage').val(pageTitle + ' #'+pageId);
              }
            }
          );
        }
      );
    </script>
  </body>
</html>
