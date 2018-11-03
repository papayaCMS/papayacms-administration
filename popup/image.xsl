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
      <popup:phrase>Select image</popup:phrase>
      <popup:phrase>Size</popup:phrase>
      <popup:phrase>Width</popup:phrase>
      <popup:phrase>Height</popup:phrase>
      <popup:phrase>Absolute</popup:phrase>
      <popup:phrase>Maximum</popup:phrase>
      <popup:phrase>Minimum</popup:phrase>
      <popup:phrase>Minimum Cropped</popup:phrase>
      <popup:phrase>Get Original Size</popup:phrase>
      <popup:phrase>OK</popup:phrase>
      <popup:phrase>Cancel</popup:phrase>
    </popup:phrases>
  </popup:popup>

  <xsl:output method="html" encoding="UTF-8" standalone="yes" indent="yes" />

  <xsl:template match="/">
    <html>
      <head>
        <title><xsl:value-of select="//popup:phrase[@identifier='Select image']"/></title>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <link rel="stylesheet" type="text/css" href="../styles/css.popup" />
        <script type="text/javascript">
          var mediaFileData = {
            id : '',
            width : 0,
            height : 0,
            orgWidth : 0,
            orgHeight : 0,
            resizeMode : 'max'
          };
          var bProtextProportions = true;
          var papayaContext = null;
        </script>
        <script type="text/javascript" src="../script/xmlrpc.js"> </script>
        <script type="text/javascript" src="image.js"> </script>
      </head>
      <body id="popup">
        <div class="title">
          <div class="artworkOverlay">
            <xsl:copy-of select="document('../template/svg/dots.svg')/*"/>
          </div>
          <h1 id="popupTitle"><xsl:value-of select="//popup:phrase[@identifier='Select image']"/></h1>
        </div>


        <form action="#">
          <div id="divImage">
             <div id="divPreview" style="width: 280px;  float: left; padding: 5px;">
              <iframe src="about:blank" id="iframePreview" name="iframePreview" class="iframePreview" frameborder="0" scrolling="no"> </iframe>
             </div>

             <fieldset style="width: 260px; float: right; margin-right: 5px;">
               <legend ><xsl:value-of select="//popup:phrase[@identifier='Size']"/></legend>
               <table border="0" style="width: 260px;" class="dialogXXSmall" summary="">
                 <tr style="vertical-align: middle;">
                   <td>
                     <label ><xsl:value-of select="//popup:phrase[@identifier='Width']"/></label>
                     <input type="text" class="dialogInput dialogScale" id="editSizeWidth" onchange="OnChangeWidth();" />
                   </td>
                   <td>
                     <a href="#"><img src="../pics/controls/size_linked_on.gif"
                       alt="Protect Proportions" style="width:19px; height:8px; border: none;"
                       id="imageProtectProportions" onclick="switchProtectProportions();"/></a>
                   </td>
                   <td>
                     <label ><xsl:value-of select="//popup:phrase[@identifier='Height']"/></label>
                     <input type="text" class="dialogInput dialogScale" id="editSizeHeight" onchange="OnChangeHeight();" />
                   </td>
                 </tr>
               </table>
               <table border="0" style="width: 260px;" summary="">
                 <tr>
                   <td class="symbolSize">
                     <a href="#"><img
                       src="../pics/controls/size_abs.gif"
                       id="imageSizeAbs"
                       class="symbolSize"
                       alt="{//popup:phrase[@identifier='Absolute']}"
                       title="{//popup:phrase[@identifier='Absolute']}"
                       onclick="selectResize('abs');" /></a>
                   </td>
                   <td class="symbolSize">
                     <a href="#"><img
                       src="../pics/controls/size_max.gif" id="imageSizeMax"
                       class="symbolSize"
                       alt="{//popup:phrase[@identifier='Maximum']}"
                       title="{//popup:phrase[@identifier='Maximum']}"
                       onclick="selectResize('max');" /></a>
                   </td>
                   <td class="symbolSize">
                     <a href="#"><img
                       src="../pics/controls/size_min.gif"
                       id="imageSizeMin"
                       class="symbolSize"
                       alt="{//popup:phrase[@identifier='Minimum']}"
                       title="{//popup:phrase[@identifier='Minimum']}"
                       onclick="selectResize('min');" /></a>
                   </td>
                   <td class="symbolSize">
                     <a href="#"><img
                       src="../pics/controls/size_mincrop.gif"
                       id="imageSizeMinCrop"
                       class="symbolSize"
                       alt="{//popup:phrase[@identifier='Minimum Cropped']}"
                       title="{//popup:phrase[@identifier='Minimum Cropped']}"
                       onclick="selectResize('mincrop');" /></a>
                   </td>
                   <td style="padding-left: 10px;">
                     <a href="#"><img
                       src="../pics/controls/size_getorg.gif"
                       style="border: none; width: 16px; height: 32px; padding: 0 2px"
                       alt="{//popup:phrase[@identifier='Get Original Size']}"
                       title="{//popup:phrase[@identifier='Get Original Size']}"
                       onclick="getOriginalSize();" /></a>
                   </td>
                 </tr>
               </table>
             </fieldset>
            </div>
            <div class="popupButtonsArea">
              <input type="button" onclick="selectImage();" value="{//popup:phrase[@identifier='Select image']}"
                class="dialogButton buttonLeft"/>
              <input type="button" value="{//popup:phrase[@identifier='OK']}" class="dialogButton"
                papayaLang="DlgBtnOk" data-action="resolve"/>
              <input type="button" value="{//popup:phrase[@identifier='Cancel']}" class="dialogButton"
                papayaLang="DlgBtnCancel" data-action="reject"/>
            </div>
          </form>

          <div class="footer">
            <div class="artworkOverlay">
              <xsl:copy-of select="document('../template/svg/dots.svg')/*"/>
            </div>
          </div>
          <script type="text/javascript" src="../script/jquery/js/jquery-1.7.2.min.js"> </script>
          <script type="text/javascript" src="../script/jquery.papayaUtilities.js"> </script>
          <script type="text/javascript">
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
                    window.papayaContext.defer.resolve(mediaFileData);
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
              jQuery.waitUntil(
                function () {
                  return (window.papayaContext != null);
                },
                2000
              ).done(
                function () {
                  initializeImageData(window.papayaContext.data);
                }
              );
            }
          );
        </script>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
