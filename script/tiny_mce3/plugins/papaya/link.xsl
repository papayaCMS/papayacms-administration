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
    <popup:options>
      <popup:option name="PAPAYA_RICHTEXT_LINK_TARGET">_self</popup:option>
    </popup:options>
  </popup:popup>

  <xsl:output method="html" encoding="UTF-8" standalone="yes" indent="yes" />

  <xsl:template match="/">
    <html>
      <head>
        <title>{#papaya.link_title}</title>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <link rel="stylesheet" type="text/css" href="css/papaya.css" />
        <script language="javascript" type="text/javascript" src="../../tiny_mce_popup.js"> </script>
        <script language="javascript" type="text/javascript" src="../../utils/mctabs.js"> </script>
        <script language="javascript" type="text/javascript" src="../../utils/form_utils.js"> </script>
        <script language="javascript" type="text/javascript" src="../../utils/validate.js"> </script>

        <link rel="stylesheet" type="text/css" href="css/papaya.css" />
        <script language="javascript" type="text/javascript" src="../../../jquery/js/jquery-1.7.2.min.js"> </script>
        <script language="javascript" type="text/javascript" src="../../../jquery.papayaUtilities.js"> </script>
        <script language="javascript" type="text/javascript" src="../../../jquery.papayaPopUp.js"> </script>
        <script language="javascript" type="text/javascript" src="js/jsonclass.js"> </script>
        <script language="javascript" type="text/javascript" src="js/papayatag.js"> </script>
        <script language="javascript" type="text/javascript" src="js/papayautils.js"> </script>
        <script language="javascript" type="text/javascript" src="js/papayaform.js"> </script>
        <script language="javascript" type="text/javascript" src="js/link_dlg.js"> </script>
      </head>
      <body id="papayaLink" style="display: none">
        <form name="linkForm" onsubmit="PapayaLinkDialog.apply();">
          <xsl:attribute name="action">javascript:function(){}();</xsl:attribute>
          <div class="tabs">
            <ul>
              <li id="page_tab" class="current"><span><a href="#" onclick="PapayaLinkDialog.displayTab('page_tab','page_panel');return false;">{#papaya.link_tab_page}</a></span></li>
              <li id="url_tab"><span><a href="#" onclick="PapayaLinkDialog.displayTab('url_tab','url_panel');return false;">{#papaya.link_tab_url}</a></span></li>
              <li id="email_tab"><span><a href="#" onclick="PapayaLinkDialog.displayTab('email_tab','email_panel');return false;">{#papaya.link_tab_email}</a></span></li>
            </ul>
          </div>
          <div class="panel_wrapper">
            <div id="page_panel" class="panel current">
              <table class="properties" summary="">
                <tr>
                  <td class="columnLabel"><label id="pageidlabel" for="pageid">{#papaya.link_pageid_title}</label></td>
                  <td class="columnElement"><input type="text" name="pageid" id="pageid" value="" class="dialogScale"/></td>
                  <td>
                    <table style="width: 100%;" cellpadding="0" cellspacing="0" summary="">
                      <tbody>
                      <tr>
                        <td style="width: 16px; height: 16px;">
                          <button class="mceButtonNormal" type="button"
                            onclick="PapayaLinkDialog.browsePages('input#pageid');"
                            onmouseover="this.className='mceButtonOver'" onmouseout="this.className='mceButtonNormal'">
                            <img style="width: 16px; height: 16px;" src="img/page.svg" alt="" />
                          </button>
                        </td>
                      </tr>
                      </tbody>
                    </table>
                  </td>
                </tr>
                <tr>
                  <td class="columnLabel"><label id="pageidtextlabel" for="pageidtext">{#papaya.link_pagetext_title}</label></td>
                  <td colspan="2"><input type="text" name="pageidtext" id="pageidtext" value="" class="dialogScale"/></td>
                </tr>
                <tr>
                  <td class="columnLabel"><label id="pageidtitlelabel" for="pageidtitle">{#papaya.link_pagetitle_title}</label></td>
                  <td colspan="2"><input type="text" name="pageidtitle" id="pageidtitle" value="" class="dialogScale"/></td>
                </tr>
                <tr>
                  <td class="columnLabel"><label id="pageidcsslabel" for="pageidcss">{#papaya.link_css_class}</label></td>
                  <td colspan="2"><input type="text" name="pageidcss" id="pageidcss" value="" class="dialogScale"/></td>
                </tr>
                <tr>
                  <td class="columnLabel"><label id="pageidtextmodelabel" for="pageidtextmode">{#papaya.link_textmode_title}</label></td>
                  <td colspan="2">
                    <select name="pageidtextmode" id="pageidtextmode" class="dialogScale">
                      <option value="auto">{#papaya.link_textmode_auto}</option>
                      <option value="yes" selected="selected">{#papaya.link_textmode_yes}</option>
                      <option value="no">{#papaya.link_textmode_no}</option>
                    </select>
                  </td>
                </tr>
                <tr>
                  <td class="columnLabel"><label id="pageidtargetlabel" for="pageidtarget">{#papaya.link_target_title}</label></td>
                  <td colspan="2">
                    <select name="pageidtarget" id="pageidtarget" class="dialogScale">
                      <option value="_self" selected="selected">{#papaya.link_target_self}</option>
                      <option value="_blank">{#papaya.link_target_blank}</option>
                    </select>
                  </td>
                </tr>
              </table>
              <fieldset>
                <legend>{#papaya.link_popup_title}</legend>
                <table class="properties" summary="">
                  <tr>
                    <td colspan="2" style="line-height: 20px;"><input type="checkbox" name="pageidpopupuse" id="pageidpopupuse" style="float: left;"/> <label id="pageidpopupuselabel" for="pageidpopupuse">{#papaya.link_popup_use}</label></td>
                  </tr>
                  <tr>
                    <td class="columnLabel"><label id="pageidpopupwidthlabel" for="pageidpopupwidth">{#papaya.link_popup_width}</label></td>
                    <td class="columnElement"><input type="text" name="pageidpopupwidth" id="pageidpopupwidth" value="" class="dialogScale"/></td>
                  </tr>
                  <tr>
                    <td class="columnLabel"><label id="pageidpopupheightlabel" for="pageidpopupheight">{#papaya.link_popup_height}</label></td>
                    <td class="columnElement"><input type="text" name="pageidpopupheight" id="pageidpopupheight" value="" class="dialogScale"/></td>
                  </tr>
                  <tr>
                    <td>&#160;</td>
                    <td>
                      <input type="checkbox" name="pageidpopupscrollbars" id="pageidpopupscrollbars" value="yes" />
                      <label for="pageidpopupscrollbars">{#papaya.link_popup_scrollbars}</label>
                      <input type="checkbox" name="pageidpopupresize" id="pageidpopupresize" value="yes" />
                      <label for="pageidpopupresize">{#papaya.link_popup_resize}</label>
                      <input type="checkbox" name="pageidpopuptoolbar" id="pageidpopuptoolbar" value="yes" />
                      <label for="pageidpopuptoolbar">{#papaya.link_popup_toolbar}</label>
                    </td>
                  </tr>
                </table>
              </fieldset>
            </div>
            <div id="url_panel" class="panel">
              <table class="properties" summary="">
                <tr>
                  <td class="columnLabel"><label id="urllabel" for="url">{#papaya.link_url_title}</label></td>
                  <td class="columnElement"><input type="text" name="url" id="url" value="" class="dialogScale"/></td>
                </tr>
                <tr>
                  <td class="columnLabel"><label id="urltextlabel" for="urltext">{#papaya.link_urltext_title}</label></td>
                  <td class="columnElement"><input type="text" name="urltext" id="urltext" value="" class="dialogScale"/></td>
                </tr>
                <tr>
                  <td class="columnLabel"><label id="urlttitlelabel" for="urltitle">{#papaya.link_urltitle_title}</label></td>
                  <td class="columnElement"><input type="text" name="urltitle" id="urltitle" value="" class="dialogScale"/></td>
                </tr>
                <tr>
                  <td class="columnLabel"><label id="urlcsslabel" for="urlcss">{#papaya.link_css_class}</label></td>
                  <td class="columnElement"><input type="text" name="urlcss" id="urlcss" value="" class="dialogScale"/></td>
                </tr>
                <tr>
                  <td class="columnLabel"><label id="urltargetlabel" for="urltarget">{#papaya.link_target_title}</label></td>
                  <td class="columnElement">
                    <select name="urltarget" id="urltarget" class="dialogScale">
                      <option value="_self">
                        <xsl:if test="//popup:option[@name='PAPAYA_RICHTEXT_LINK_TARGET'] = '_self'">
                          <xsl:attribute name="selected">selected</xsl:attribute>
                        </xsl:if>
                        {#papaya.link_target_self}
                      </option>
                      <option value="_blank">
                        <xsl:if test="//popup:option[@name='PAPAYA_RICHTEXT_LINK_TARGET'] = '_blank'">
                          <xsl:attribute name="selected">selected</xsl:attribute>
                        </xsl:if>
                        {#papaya.link_target_blank}
                      </option>
                    </select>
                  </td>
                </tr>
                <tr>
                  <td class="columnLabel">&#160;</td>
                  <td class="columnElement">
                      <input type="checkbox" name="urlnofollow" id="urlnofollow" value="yes" />
                      <label for="urlnofollow">{#papaya.link_nofollow}</label>
                  </td>
                </tr>
              </table>
              <fieldset>
                <legend>{#papaya.link_popup_title}</legend>
                <table class="properties" summary="">
                  <tr>
                    <td colspan="2" style="line-height: 20px;"><input type="checkbox" name="urlpopupuse" id="urlpopupuse" style="float: left;"/> <label id="urlpopupuselabel" for="urlpopupuse">{#papaya.link_popup_use}</label></td>
                  </tr>
                  <tr>
                    <td class="columnLabel"><label id="urlpopupwidthlabel" for="urlpopupwidth">{#papaya.link_popup_width}</label></td>
                    <td class="columnElement"><input type="text" name="urlpopupwidth" id="urlpopupwidth" value="" class="dialogScale"/></td>
                  </tr>
                  <tr>
                    <td class="columnLabel"><label id="urlpopupheightlabel" for="urlpopupheight">{#papaya.link_popup_height}</label></td>
                    <td class="columnElement"><input type="text" name="urlpopupheight" id="urlpopupheight" value="" class="dialogScale"/></td>
                  </tr>
                  <tr>
                    <td>&#160;</td>
                    <td>
                      <input type="checkbox" name="urlpopupscrollbars" id="urlpopupscrollbars" value="yes" />
                      <label for="urlpopupscrollbars">{#papaya.link_popup_scrollbars}</label>
                      <input type="checkbox" name="urlpopupresize" id="urlpopupresize" value="yes" />
                      <label for="urlpopupresize">{#papaya.link_popup_resize}</label>
                      <input type="checkbox" name="urlpopuptoolbar" id="urlpopuptoolbar" value="yes" />
                      <label for="urlpopuptoolbar">{#papaya.link_popup_toolbar}</label>
                    </td>
                  </tr>
                </table>
              </fieldset>
            </div>
            <div id="email_panel" class="panel">
              <table class="properties" summary="">
                <tr>
                  <td class="columnLabel"><label id="emaillabel" for="email">{#papaya.link_email_title}</label></td>
                  <td class="columnElement"><input type="text" name="email" id="email" value="" class="dialogScale"/></td>
                </tr>
                <tr>
                  <td class="columnLabel"><label id="emailsubjectlabel" for="emailsubject">{#papaya.link_emailsubject_title}</label></td>
                  <td class="columnElement"><input type="text" name="emailsubject" id="emailsubject" value="" class="dialogScale"/></td>
                </tr>
                <tr>
                  <td class="columnLabel"><label id="emailtextlabel" for="emailtext">{#papaya.link_pagetext_title}</label></td>
                  <td class="columnElement"><input type="text" name="emailtext" id="emailtext" value="" class="dialogScale"/></td>
                </tr>
                <tr>
                  <td class="columnLabel"><label id="emailtitlelabel" for="emailtitle">{#papaya.link_pagetitle_title}</label></td>
                  <td class="columnElement"><input type="text" name="emailtitle" id="emailtitle" value="" class="dialogScale"/></td>
                </tr>
                <tr>
                  <td class="columnLabel"><label id="emailcsslabel" for="emailcss">{#papaya.link_css_class}</label></td>
                  <td class="columnElement"><input type="text" name="emailcss" id="emailcss" value="" class="dialogScale"/></td>
                </tr>
              </table>
            </div>
          </div>
          <div class="mceActionPanel">
            <div style="float: left">
              <input type="submit" id="insert" name="insert">
                <xsl:attribute name="value">{#insert}</xsl:attribute>
              </input>
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
