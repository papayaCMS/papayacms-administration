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
      <popup:phrase>Image browser</popup:phrase>
    </popup:phrases>
  </popup:popup>

  <xsl:output method="html" encoding="UTF-8" standalone="yes" indent="yes" />

  <xsl:template match="/">
    <html>
      <head>
        <title><xsl:value-of select="//popup:phrase[@identifier='Image browser']"/></title>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <link rel="stylesheet" type="text/css" href="../styles/css.popup" />
        <script type="text/javascript" src="../script/imgbrowser.js"><xsl:text> </xsl:text></script>
        <script type="text/javascript">
          var linkList = "../content.file.browser?mdb[mode]=list";
          var linkPreview = "../content.file.browser?mdb[mode]=preview&amp;mdb[imagesonly]=1";
          var linkThumbs = "../content.file.browser?mdb[mode]=thumbs&amp;mdb[dialog]=no&amp;mdb[imagesonly]=1";

          var mediaFileData = {};
          var papayaContext = null;

          function Cancel() {
            if (papayaContext) {
              papayaContext.defer.reject();
            }
            if (!window.frameElement) {
              window.close();
            }
          }

          function Ok() {
            if (papayaContext) {
              papayaContext.defer.resolve(mediaFileData);
            } else if ((typeof linkedObject != 'undefined') &amp;&amp; linkedObject != null) {
              if (linkedObject.setMediaFileData) {
                linkedObject.setMediaFileData(mediaFileData.id, mediaFileData);
              }
            } else if (window.opener.setMediaFileData) {
              window.opener.setMediaFileData(mediaFileData.id, mediaFileData);
            }
            if (!window.frameElement) {
              window.close();
            }
          }

          function setMediaFileData(fileId, fileData) {
            mediaFileData = fileData;
            mediaFileData.orgWidth = fileData.width;
            mediaFileData.orgHeight = fileData.height;
          }
        </script>
      </head>
      <frameset rows="40,*,50" style="border: none;" frameborder="no" border="0" framespacing="0">
        <frame src="media-header" style="border: none;"/>
        <frameset cols="300,*" style="border-width: 3px;" frameborder="yes" border="3"
          framespacing="3" bordercolor="#FFFFFF">
          <frameset rows="*,200">
            <frame src="../content.files.browser?mdb[mode]=list" id="frmFolders"/>
            <frame id="frmPreview" scrolling="no"
              src="../content.files.browser?mdb[mode]=preview&amp;mdb[imagesonly]=1"/>
          </frameset>
          <frame id="frmThumbs"
            src="../content.files.browser?mdb[mode]=thumbs&amp;mdb[dialog]=no&amp;mdb[imagesonly]=1"/>
        </frameset>
        <frame src="media-footer" style="border: none;"/>
      </frameset>
    </html>
  </xsl:template>

</xsl:stylesheet>
