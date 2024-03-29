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

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="sheet">
    <xsl:param name="sheet"/>
    <div class="sheetBackground">
      <div class="sheetShadow">
        <xsl:if test="$sheet/@width">
          <xsl:attribute name="style">width:
            <xsl:value-of select="$sheet/@width"/>
          </xsl:attribute>
        </xsl:if>
        <div class="sheet">
          <xsl:attribute name="style">
            <xsl:if test="$sheet/@padding">
              <xsl:text>padding: </xsl:text>
              <xsl:value-of select="$sheet/@padding"/>
            </xsl:if>
          </xsl:attribute>
          <xsl:call-template name="sheet-header">
            <xsl:with-param name="header" select="$sheet/header"/>
          </xsl:call-template>
          <xsl:choose>
            <xsl:when test="count($sheet/text//p) &gt; 0">
              <xsl:apply-templates select="$sheet/text/*|$sheet/text/text()" mode="allowHTML"/>
            </xsl:when>
            <xsl:when test="text">
              <div class="teletype">
                <xsl:apply-templates select="$sheet/text/*|$sheet/text/text()" mode="allowHTML"/>
              </div>
            </xsl:when>
          </xsl:choose>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="sheet-header">
    <xsl:param name="header"/>
    <xsl:if test="$header">
      <div class="header">
        <xsl:if test="normalize-space($header/title) != ''">
          <div class="headertitle">
            <xsl:value-of select="$header/title"/>
          </div>
        </xsl:if>
        <xsl:for-each select="$header/subtitle">
          <div class="headersubtitle">
            <xsl:value-of select="."/>
          </div>
        </xsl:for-each>
        <xsl:for-each select="$header/lines/line">
          <div class="{@class}">
            <xsl:apply-templates/>
          </div>
        </xsl:for-each>
        <xsl:if test="count($header/infos/line) &gt; 0">
          <div class="infos">
            <xsl:for-each select="$header/infos/line">
              <span class="info">
                <xsl:apply-templates/>
              </span>
            </xsl:for-each>
          </div>
        </xsl:if>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="sheet">
    <xsl:call-template name="sheet">
      <xsl:with-param name="sheet" select="."/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="img" mode="allowHTML">
    <xsl:choose>
      <xsl:when
        test="starts-with(@src, 'https://') or starts-with(@src, 'http://') or starts-with(@src, '/')">
        <xsl:copy-of select="."/>
      </xsl:when>
      <xsl:otherwise>
        <img src="{$PAGE_WEB_PATH}{@src}">
          <xsl:copy-of select="@*[local-name() != 'src']"/>
        </img>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
