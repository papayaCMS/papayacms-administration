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
      <popup:phrase>Select File</popup:phrase>
    </popup:phrases>
  </popup:popup>

  <xsl:output method="html" encoding="UTF-8" standalone="yes" indent="yes" />

  <xsl:template match="/">
    <html>
      <head>
        <title><xsl:value-of select="//popup:phrase[@identifier='Select File']"/></title>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <link rel="stylesheet" type="text/css" href="../styles/css.popup" />
      </head>
      <body id="popup">
        <div class="title">
          <div class="artworkOverlay">
            <xsl:copy-of select="document('../template/svg/dots.svg')/*"/>
          </div>
          <h1 id="popupTitle"><xsl:value-of select="//popup:phrase[@identifier='Select File']"/></h1>
        </div>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
