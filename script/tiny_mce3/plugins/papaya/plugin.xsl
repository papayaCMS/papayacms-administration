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
    <popup:plugins type="parser"/>
  </popup:popup>

  <xsl:output method="html" encoding="UTF-8" standalone="yes" indent="yes" />

  <xsl:template match="/">
    <html>
      <head>
        <title>{#papaya.addon_title}</title>
        <script language="javascript" type="text/javascript" src="../../tiny_mce_popup.js"> </script>
        <script language="javascript" type="text/javascript" src="../../utils/mctabs.js"> </script>
        <script language="javascript" type="text/javascript" src="../../utils/form_utils.js"> </script>
        <script language="javascript" type="text/javascript" src="../../utils/validate.js"> </script>

        <link rel="stylesheet" type="text/css" href="css/papaya.css" />
        <script language="javascript" type="text/javascript" src="../../../xmlrpc.js"> </script>
        <script language="javascript" type="text/javascript" src="js/jsonclass.js"> </script>
        <script language="javascript" type="text/javascript" src="js/papayatag.js"> </script>
        <script language="javascript" type="text/javascript" src="js/papayaparser.js"> </script>
        <script language="javascript" type="text/javascript" src="js/papayautils.js"> </script>
        <script language="javascript" type="text/javascript" src="js/papayaform.js"> </script>
        <script language="javascript" type="text/javascript" src="js/addon_dlg.js"> </script>
      </head>
      <body id="papayaAddOn" style="display: none">
        <form onsubmit="PapayaAddOnDialog.apply();" id="addonForm">
          <xsl:attribute name="action">javascript:function(){}();</xsl:attribute>
          <fieldset>
            <legend>{#papaya.addon_select}</legend>
            <select id="addon_guid" onchange="PapayaAddOnDialog.getAddOnDialog()">
              <xsl:for-each select="//popup:plugins[@type='parser']/popup:plugin">
                <option value="{@guid}"><xsl:value-of select="@title"/></option>
              </xsl:for-each>
            </select>
          </fieldset>
          <fieldset>
            <div id="dynamicDialog"> </div>
          </fieldset>
          <div class="mceActionPanel">
            <div style="float: left; clear: both;">
              <input type="submit" id="insert" name="insert" style="float: left;">
                <xsl:attribute name="value">{#insert}</xsl:attribute>
              </input>
              <input type="button" id="browseButton" name="browseButton"
                class="browseButton" value="Browse"
                style="float: left; margin-left: 20px; display: none;"/>
            </div>
            <div style="float: right">
              <input type="button" id="cancel" name="cancel" onclick="tinyMCEPopup.close();">
                <xsl:attribute name="value">{#cancel}</xsl:attribute>
              </input>
            </div>
          </div>
          <div id="papayaErrorBox" style="display: none;">
            <div class="errorPanel">
              <img src="img/dialog-error.png" alt="" class="dialogIcon" />
              <p id="papayaErrorMsg"> </p>
              <p id="papayaErrorInfo"> </p>
              <button type="button" id="papayaErrorButton">{#close}</button>
              <div class="fixFloat"> </div>
            </div>
          </div>
        </form>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
