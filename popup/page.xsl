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
      <popup:phrase>Select page</popup:phrase>
      <popup:phrase>OK</popup:phrase>
      <popup:phrase>Cancel</popup:phrase>
    </popup:phrases>
  </popup:popup>

  <xsl:output method="html" encoding="UTF-8" standalone="yes" indent="yes" />

  <xsl:template match="/">
    <html>
      <head>
        <title><xsl:value-of select="//popup:phrase[@identifier='Select page']"/></title>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <link rel="stylesheet" type="text/css" href="../styles/css" />
        <link rel="stylesheet" type="text/css" href="../styles/css.popup" />
      </head>
      <body id="popup">
        <div class="title">
          <div class="artworkOverlay">
            <xsl:copy-of select="document('../template/svg/dots.svg')/*"/>
          </div>
          <h1 id="popupTitle"><xsl:value-of select="//popup:phrase[@identifier='Select page']"/></h1>
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
            <input type="button" value="{//popup:phrase[@identifier='OK']}" class="dialogButton"
              papayaLang="DlgBtnOk" data-action="resolve"/>
            <input type="button" value="{//popup:phrase[@identifier='Cancel']}" class="dialogButton"
              papayaLang="DlgBtnCancel" data-action="reject"/>
          </div>
        </div>
        <div class="footer">
          <div class="artworkOverlay">
            <xsl:copy-of select="document('../template/svg/dots.svg')/*"/>
          </div>
        </div>
        <script type="text/javascript" src="../script/jquery/js/jquery-1.7.2.min.js"> </script>
        <script type="text/javascript" src="../script/jquery.papayaPageTree.js"> </script>
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
  </xsl:template>

</xsl:stylesheet>
