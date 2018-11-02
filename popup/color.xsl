<?xml version="1.0" encoding="iso-8859-1"?>
<!--
  ~ papaya CMS
  ~
  ~ @copyright 2000-2018 by papayaCMS project - All rights reserved.
  ~ @link http://www.papaya-cms.com/
  ~ @license http://www.gnu.org/licenses/old-licenses/gpl-2.0.html GNU General Public License, version 2
  ~
  ~  You can redistribute and/or modify this script under the terms of the GNU General Public
  ~  License (GPL) version 2, provided that the copyright and license notes, including these
  ~  lines, remain unmodified. papaya is distributed in the hope that it will be useful, but
  ~  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  ~  FOR A PARTICULAR PURPOSE.
  -->

<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:popup="http://papaya-cms.com/administration/popup"
  exclude-result-prefixes="popup">

  <popup:popup>
    <popup:phrases>
      <popup:phrase>Select color</popup:phrase>
      <popup:phrase>OK</popup:phrase>
      <popup:phrase>Cancel</popup:phrase>
    </popup:phrases>
  </popup:popup>

  <xsl:output method="html" encoding="UTF-8" standalone="yes" indent="yes" />

  <xsl:template match="/">
    <html>
      <head>
        <title><xsl:value-of select="//popup:phrase[@identifier='Select color']"/></title>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <link rel="stylesheet" type="text/css" href="../styles/css.popup" />
        <style type="text/css">
          table {
            border-collapse: collapse;
            margin-bottom: 3px;
          }
          table td {
            border: 1px solid black;
            width: 19px;
            height: 12px;
            font-size: 1px;
          }
          table th {
            border: 1px solid black;
            background-color: #000;
            padding: 20px;
          }
          table th input {
            border: 1px solid black;
            background-color: #FFF;
            padding: 2px;
            font-size: 12px;
          }
        </style>
      </head>
      <body id="popup">
        <div class="title">
          <div class="artworkOverlay">
            <xsl:copy-of select="document('../template/svg/dots.svg')/*"/>
          </div>
          <h1 id="popupTitle"><xsl:value-of select="//popup:phrase[@identifier='Select color']"/></h1>
        </div>
        <form action="#" class="colorSelector">
          <table>
            <tr>
              <th colspan="18">
                 <input type="text"/>
              </th>
            </tr>
            <tr>
              <td style="background-color: #FFFFFF">&#160;</td>
              <td style="background-color: #FFCCFF">&#160;</td>
              <td style="background-color: #FF99FF">&#160;</td>
              <td style="background-color: #FF66FF">&#160;</td>
              <td style="background-color: #FF33FF">&#160;</td>
              <td style="background-color: #FF00FF">&#160;</td>
              <td style="background-color: #FFFFCC">&#160;</td>
              <td style="background-color: #FFCCCC">&#160;</td>
              <td style="background-color: #FF99CC">&#160;</td>
              <td style="background-color: #FF66CC">&#160;</td>
              <td style="background-color: #FF33CC">&#160;</td>
              <td style="background-color: #FF00CC">&#160;</td>
              <td style="background-color: #FFFF99">&#160;</td>
              <td style="background-color: #FFCC99">&#160;</td>
              <td style="background-color: #FF9999">&#160;</td>
              <td style="background-color: #FF6699">&#160;</td>
              <td style="background-color: #FF3399">&#160;</td>
              <td style="background-color: #FF0099">&#160;</td>
            </tr>
            <tr>
              <td style="background-color: #CCFFFF">&#160;</td>
              <td style="background-color: #CCCCFF">&#160;</td>
              <td style="background-color: #CC99FF">&#160;</td>
              <td style="background-color: #CC66FF">&#160;</td>
              <td style="background-color: #CC33FF">&#160;</td>
              <td style="background-color: #CC00FF">&#160;</td>
              <td style="background-color: #CCFFCC">&#160;</td>
              <td style="background-color: #CCCCCC">&#160;</td>
              <td style="background-color: #CC99CC">&#160;</td>
              <td style="background-color: #CC66CC">&#160;</td>
              <td style="background-color: #CC33CC">&#160;</td>
              <td style="background-color: #CC00CC">&#160;</td>
              <td style="background-color: #CCFF99">&#160;</td>
              <td style="background-color: #CCCC99">&#160;</td>
              <td style="background-color: #CC9999">&#160;</td>
              <td style="background-color: #CC6699">&#160;</td>
              <td style="background-color: #CC3399">&#160;</td>
              <td style="background-color: #CC0099">&#160;</td>
            </tr>
            <tr>
              <td style="background-color: #99FFFF">&#160;</td>
              <td style="background-color: #99CCFF">&#160;</td>
              <td style="background-color: #9999FF">&#160;</td>
              <td style="background-color: #9966FF">&#160;</td>
              <td style="background-color: #9933FF">&#160;</td>
              <td style="background-color: #9900FF">&#160;</td>
              <td style="background-color: #99FFCC">&#160;</td>
              <td style="background-color: #99CCCC">&#160;</td>
              <td style="background-color: #9999CC">&#160;</td>
              <td style="background-color: #9966CC">&#160;</td>
              <td style="background-color: #9933CC">&#160;</td>
              <td style="background-color: #9900CC">&#160;</td>
              <td style="background-color: #99FF99">&#160;</td>
              <td style="background-color: #99CC99">&#160;</td>
              <td style="background-color: #999999">&#160;</td>
              <td style="background-color: #996699">&#160;</td>
              <td style="background-color: #993399">&#160;</td>
              <td style="background-color: #990099">&#160;</td>
            </tr>
            <tr>
              <td style="background-color: #66FFFF">&#160;</td>
              <td style="background-color: #66CCFF">&#160;</td>
              <td style="background-color: #6699FF">&#160;</td>
              <td style="background-color: #6666FF">&#160;</td>
              <td style="background-color: #6633FF">&#160;</td>
              <td style="background-color: #6600FF">&#160;</td>
              <td style="background-color: #66FFCC">&#160;</td>
              <td style="background-color: #66CCCC">&#160;</td>
              <td style="background-color: #6699CC">&#160;</td>
              <td style="background-color: #6666CC">&#160;</td>
              <td style="background-color: #6633CC">&#160;</td>
              <td style="background-color: #6600CC">&#160;</td>
              <td style="background-color: #66FF99">&#160;</td>
              <td style="background-color: #66CC99">&#160;</td>
              <td style="background-color: #669999">&#160;</td>
              <td style="background-color: #666699">&#160;</td>
              <td style="background-color: #663399">&#160;</td>
              <td style="background-color: #660099">&#160;</td>
            </tr>
            <tr>
              <td style="background-color: #33FFFF">&#160;</td>
              <td style="background-color: #33CCFF">&#160;</td>
              <td style="background-color: #3399FF">&#160;</td>
              <td style="background-color: #3366FF">&#160;</td>
              <td style="background-color: #3333FF">&#160;</td>
              <td style="background-color: #3300FF">&#160;</td>
              <td style="background-color: #33FFCC">&#160;</td>
              <td style="background-color: #33CCCC">&#160;</td>
              <td style="background-color: #3399CC">&#160;</td>
              <td style="background-color: #3366CC">&#160;</td>
              <td style="background-color: #3333CC">&#160;</td>
              <td style="background-color: #3300CC">&#160;</td>
              <td style="background-color: #33FF99">&#160;</td>
              <td style="background-color: #33CC99">&#160;</td>
              <td style="background-color: #339999">&#160;</td>
              <td style="background-color: #336699">&#160;</td>
              <td style="background-color: #333399">&#160;</td>
              <td style="background-color: #330099">&#160;</td>
            </tr>
            <tr>
              <td style="background-color: #00FFFF">&#160;</td>
              <td style="background-color: #00CCFF">&#160;</td>
              <td style="background-color: #0099FF">&#160;</td>
              <td style="background-color: #0066FF">&#160;</td>
              <td style="background-color: #0033FF">&#160;</td>
              <td style="background-color: #0000FF">&#160;</td>
              <td style="background-color: #00FFCC">&#160;</td>
              <td style="background-color: #00CCCC">&#160;</td>
              <td style="background-color: #0099CC">&#160;</td>
              <td style="background-color: #0066CC">&#160;</td>
              <td style="background-color: #0033CC">&#160;</td>
              <td style="background-color: #0000CC">&#160;</td>
              <td style="background-color: #00FF99">&#160;</td>
              <td style="background-color: #00CC99">&#160;</td>
              <td style="background-color: #009999">&#160;</td>
              <td style="background-color: #006699">&#160;</td>
              <td style="background-color: #003399">&#160;</td>
              <td style="background-color: #000099">&#160;</td>
            </tr>
            <tr>
              <td style="background-color: #FFFF66">&#160;</td>
              <td style="background-color: #FFCC66">&#160;</td>
              <td style="background-color: #FF9966">&#160;</td>
              <td style="background-color: #FF6666">&#160;</td>
              <td style="background-color: #FF3366">&#160;</td>
              <td style="background-color: #FF0066">&#160;</td>
              <td style="background-color: #FFFF33">&#160;</td>
              <td style="background-color: #FFCC33">&#160;</td>
              <td style="background-color: #FF9933">&#160;</td>
              <td style="background-color: #FF6633">&#160;</td>
              <td style="background-color: #FF3333">&#160;</td>
              <td style="background-color: #FF0033">&#160;</td>
              <td style="background-color: #FFFF00">&#160;</td>
              <td style="background-color: #FFCC00">&#160;</td>
              <td style="background-color: #FF9900">&#160;</td>
              <td style="background-color: #FF6600">&#160;</td>
              <td style="background-color: #FF3300">&#160;</td>
              <td style="background-color: #FF0000">&#160;</td>
            </tr>
            <tr>
              <td style="background-color: #CCFF66">&#160;</td>
              <td style="background-color: #CCCC66">&#160;</td>
              <td style="background-color: #CC9966">&#160;</td>
              <td style="background-color: #CC6666">&#160;</td>
              <td style="background-color: #CC3366">&#160;</td>
              <td style="background-color: #CC0066">&#160;</td>
              <td style="background-color: #CCFF33">&#160;</td>
              <td style="background-color: #CCCC33">&#160;</td>
              <td style="background-color: #CC9933">&#160;</td>
              <td style="background-color: #CC6633">&#160;</td>
              <td style="background-color: #CC3333">&#160;</td>
              <td style="background-color: #CC0033">&#160;</td>
              <td style="background-color: #CCFF00">&#160;</td>
              <td style="background-color: #CCCC00">&#160;</td>
              <td style="background-color: #CC9900">&#160;</td>
              <td style="background-color: #CC6600">&#160;</td>
              <td style="background-color: #CC3300">&#160;</td>
              <td style="background-color: #CC0000">&#160;</td>
            </tr>
            <tr>
              <td style="background-color: #99FF66">&#160;</td>
              <td style="background-color: #99CC66">&#160;</td>
              <td style="background-color: #999966">&#160;</td>
              <td style="background-color: #996666">&#160;</td>
              <td style="background-color: #993366">&#160;</td>
              <td style="background-color: #990066">&#160;</td>
              <td style="background-color: #99FF33">&#160;</td>
              <td style="background-color: #99CC33">&#160;</td>
              <td style="background-color: #999933">&#160;</td>
              <td style="background-color: #996633">&#160;</td>
              <td style="background-color: #993333">&#160;</td>
              <td style="background-color: #990033">&#160;</td>
              <td style="background-color: #99FF00">&#160;</td>
              <td style="background-color: #99CC00">&#160;</td>
              <td style="background-color: #999900">&#160;</td>
              <td style="background-color: #996600">&#160;</td>
              <td style="background-color: #993300">&#160;</td>
              <td style="background-color: #990000">&#160;</td>
            </tr>
            <tr>
              <td style="background-color: #66FF66">&#160;</td>
              <td style="background-color: #66CC66">&#160;</td>
              <td style="background-color: #669966">&#160;</td>
              <td style="background-color: #666666">&#160;</td>
              <td style="background-color: #663366">&#160;</td>
              <td style="background-color: #660066">&#160;</td>
              <td style="background-color: #66FF33">&#160;</td>
              <td style="background-color: #66CC33">&#160;</td>
              <td style="background-color: #669933">&#160;</td>
              <td style="background-color: #666633">&#160;</td>
              <td style="background-color: #663333">&#160;</td>
              <td style="background-color: #660033">&#160;</td>
              <td style="background-color: #66FF00">&#160;</td>
              <td style="background-color: #66CC00">&#160;</td>
              <td style="background-color: #669900">&#160;</td>
              <td style="background-color: #666600">&#160;</td>
              <td style="background-color: #663300">&#160;</td>
              <td style="background-color: #660000">&#160;</td>
            </tr>
            <tr>
              <td style="background-color: #33FF66">&#160;</td>
              <td style="background-color: #33CC66">&#160;</td>
              <td style="background-color: #339966">&#160;</td>
              <td style="background-color: #336666">&#160;</td>
              <td style="background-color: #333366">&#160;</td>
              <td style="background-color: #330066">&#160;</td>
              <td style="background-color: #33FF33">&#160;</td>
              <td style="background-color: #33CC33">&#160;</td>
              <td style="background-color: #339933">&#160;</td>
              <td style="background-color: #336633">&#160;</td>
              <td style="background-color: #333333">&#160;</td>
              <td style="background-color: #330033">&#160;</td>
              <td style="background-color: #33FF00">&#160;</td>
              <td style="background-color: #33CC00">&#160;</td>
              <td style="background-color: #339900">&#160;</td>
              <td style="background-color: #336600">&#160;</td>
              <td style="background-color: #333300">&#160;</td>
              <td style="background-color: #330000">&#160;</td>
            </tr>
            <tr>
              <td style="background-color: #00FF66">&#160;</td>
              <td style="background-color: #00CC66">&#160;</td>
              <td style="background-color: #009966">&#160;</td>
              <td style="background-color: #006666">&#160;</td>
              <td style="background-color: #003366">&#160;</td>
              <td style="background-color: #000066">&#160;</td>
              <td style="background-color: #00FF33">&#160;</td>
              <td style="background-color: #00CC33">&#160;</td>
              <td style="background-color: #009933">&#160;</td>
              <td style="background-color: #006633">&#160;</td>
              <td style="background-color: #003333">&#160;</td>
              <td style="background-color: #000033">&#160;</td>
              <td style="background-color: #00FF00">&#160;</td>
              <td style="background-color: #00CC00">&#160;</td>
              <td style="background-color: #009900">&#160;</td>
              <td style="background-color: #006600">&#160;</td>
              <td style="background-color: #003300">&#160;</td>
              <td style="background-color: #000000">&#160;</td>
            </tr>
          </table>
          <div class="popupButtonsArea" style="text-align: right; white-space: nowrap; border: none;">
            <input type="button" value="{//popup:phrase[@identifier='OK']}" class="dialogButton"
              papayaLang="DlgBtnOk" data-action="resolve"/>
            <input type="button" value="{//popup:phrase[@identifier='Cancel']}" class="dialogButton"
              papayaLang="DlgBtnCancel" data-action="reject"/>
          </div>
        </form>
        <div class="footer">
          <div class="footerArtworkOverlay"> </div>
        </div>
        <script type="text/javascript" src="../script/jquery/js/jquery-1.7.2.min.js"><xsl:text> </xsl:text></script>
        <script type="text/javascript" src="../script/jquery.papayaUtilities.js"><xsl:text> </xsl:text></script>
        <script type="text/javascript">
          var papayaContext = null;

          (function($) {
             dialog = {

               node : null,

               selected : '',

               settings : {
                 selectors : {
                   preview : 'th',
                   input : 'th input',
                   colors : 'td',
                   confirm : '[data-action=resolve]',
                   cancel : '[data-action=reject]'
                 }
               },

               setUp : function(node, settings) {
                 this.node = node;
                 this.settings = $.extend(true, this.settings, settings);
                 var that = this;
                 this.node.find(this.settings.selectors.colors).each(
                   function () {
                     var color = $(this).css('background-color');
                     $(this).click(
                       function () {
                         that.select(color);
                       }
                     );
                   }
                 );
                 jQuery(window).on(
                   'keyup',
                   function (event) {
                     if (event.keyCode == 27) {
                       $(that.settings.selectors.cancel).click();
                     }
                   }
                 );
                 this.node.find(this.settings.selectors.confirm).click(
                   $.proxy(this.confirm, this)
                 );
                 this.node.find(this.settings.selectors.cancel).click(
                   $.proxy(this.cancel, this)
                 );
               },

               select : function(color) {
                 if (color != null) {
                   var r = null;
                   if (r = color.match(/rgb\(?([0-9]+),\s*([0-9]+),\s*([0-9]+)\)/)) {
                     color = '#' +
                       this.padLeft(parseInt(r[1]).toString(16), 2, '0') +
                       this.padLeft(parseInt(r[2]).toString(16), 2, '0') +
                       this.padLeft(parseInt(r[3]).toString(16), 2, '0');
                   } else if (r = color.match(/^#?([0-9A-Fa-f]{6})$/)) {
                     color = '#' + r[1];
                   } else if (r = color.match(/^#?([0-9A-Fa-f])([0-9A-Fa-f])([0-9A-Fa-f])$/)) {
                     color = '#' + r[1] + r[1] + r[2] + r[2] + r[3] + r[3];
                   } else {
                     color = '#000000';
                   }
                   color = color.toUpperCase();
                   this.selected = color;
                   this.node.find(this.settings.selectors.input).val(color);
                   this.node.find(this.settings.selectors.preview).css('background-color', color);
                 }
               },

               padLeft : function (string, length, character) {
                 if (length + 1 >= string.length) {
                   return Array(length + 1 - string.length).join(character) + string;
                 } else {
                   return string;
                 }
               },

               confirm : function() {
                 window.papayaContext.defer.resolve(this.selected);
                 if (!window.frameElement) {
                   window.close();
                 }
               },

               cancel : function() {
                 window.papayaContext.defer.reject();
                 if (!window.frameElement) {
                   window.close();
                 }
               }
             };

             $.fn.papayaColorDialog = function(settings) {
               this.each(
                 function () {
                   var instance = $.extend(true, {}, dialog);
                   instance.setUp($(this), settings);
                   instance.select(window.papayaContext.data);
                 }
               );
             };
          })(jQuery);

          jQuery(document).ready(
            function () {
              jQuery.waitUntil(
                function () {
                  return (window.papayaContext != null);
                },
                3000
              ).done(
                function() {
                  jQuery('.colorSelector').papayaColorDialog();
                }
              );
            }
          );
        </script>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
