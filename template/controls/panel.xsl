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

<xsl:param name="PAGE_WEB_PATH">./</xsl:param>

<xsl:template name="panel">
  <xsl:param name="title"></xsl:param>
  <xsl:param name="id"></xsl:param>
  <xsl:param name="width">100%</xsl:param>
  <xsl:param name="hint"/>
  <xsl:param name="icon"/>
  <xsl:param name="maximize"/>
  <xsl:param name="minimize"/>
  <xsl:param name="data"></xsl:param>
  <xsl:param name="buttons"/>
  <xsl:param name="toolbars"/>
  <div class="panel" style="width: {$width}">
    <xsl:if test="$id and ($id != '')">
      <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="$title and ($title != '')">
      <h2 class="panelHeader">
        <xsl:if test="$hint">
          <span class="panelInfoButton">
            <xsl:call-template name="panel-info-button">
              <xsl:with-param name="text" select="$hint" />
            </xsl:call-template>
          </span>
        </xsl:if>
        <xsl:if test="$maximize">
          <span class="panelInfoButton">
            <xsl:call-template name="panel-info-button">
              <xsl:with-param name="mode">maximize</xsl:with-param>
              <xsl:with-param name="href" select="$maximize" />
            </xsl:call-template>
          </span>
        </xsl:if>
        <xsl:if test="$minimize">
          <span class="panelInfoButton">
            <xsl:call-template name="panel-info-button">
              <xsl:with-param name="mode">minimize</xsl:with-param>
              <xsl:with-param name="href" select="$minimize" />
            </xsl:call-template>
          </span>
        </xsl:if>
        <xsl:if test="$icon">
          <span class="panelIcon">
            <xsl:call-template name="panel-icon">
              <xsl:with-param name="icon" select="$icon" />
            </xsl:call-template>
          </span>
        </xsl:if>
        <xsl:value-of select="$title"/>
      </h2>
    </xsl:if>
    <div class="panelBody">
      <xsl:if test="$buttons">
        <xsl:call-template name="listview-buttons">
          <xsl:with-param name="buttons" select="$buttons" />
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="$toolbars">
        <xsl:call-template name="listview-toolbars">
          <xsl:with-param name="toolbarLeft" select="$toolbars[@position = 'top left']"/>
          <xsl:with-param name="toolbarRight" select="$toolbars[@position = 'top right']"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:copy-of select="$data" />
      <xsl:if test="$toolbars">
        <xsl:call-template name="listview-toolbars">
          <xsl:with-param name="toolbarLeft" select="$toolbars[@position = 'bottom left']"/>
          <xsl:with-param name="toolbarRight" select="$toolbars[@position = 'bottom right']"/>
          <xsl:with-param name="positionClass">bottomToolbar</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </div>
  </div>
</xsl:template>

<xsl:template match="panel">
  <xsl:call-template name="panel">
    <xsl:with-param name="title" select="@title"/>
    <xsl:with-param name="hint" select="@hint"/>
    <xsl:with-param name="maximize" select="@maximize"/>
    <xsl:with-param name="minimize" select="@minimize"/>
    <xsl:with-param name="icon" select="@icon"/>
    <xsl:with-param name="buttons" select="buttons"/>
    <xsl:with-param name="toolbars" select="toolbar"/>
    <xsl:with-param name="data">
      <xsl:choose>
        <xsl:when test="iframe">
          <iframe
            src="{$PAGE_WEB_PATH}{iframe/@src}"
            id="{iframe/@id}"
            height="{iframe/@height}"
            style="width: 100%;"
            scrolling="auto"
            class="inset"/>
        </xsl:when>
        <xsl:when test="flash">
          <xsl:variable name="flashId" select="generate-id(flash)" />
          <object id="{$flashId}" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="{flash/@width}" height="{flash/@height}">
            <param name="movie" value="{flash/@src}"/>
            <param name="quality" value="best"/>
            <xsl:comment>[if !IE]></xsl:comment>
            <object type="application/x-shockwave-flash" data="{flash/@src}" width="{flash/@width}" height="{flash/@height}">
              <param name="quality" value="best"/>
              <xsl:comment><xsl:text disable-output-escaping="yes">&gt;![endif]</xsl:text></xsl:comment>
                <p>Sorry but you have no Flash installed.</p>
              <xsl:comment>[if !IE]></xsl:comment>
            </object>
            <xsl:comment><xsl:text disable-output-escaping="yes">&gt;![endif]</xsl:text></xsl:comment>
          </object>
          <script type="text/javascript"><xsl:comment>
            swfobject.registerObject("<xsl:value-of select="$flashId"/>", "9", "script/swfobject/expressInstall.swf");
          //</xsl:comment></script>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="panel-icon">
  <xsl:param name="icon" />
  <xsl:variable name="src">
    <xsl:call-template name="icon-url">
      <xsl:with-param name="icon-src" select="$icon"/>
    </xsl:call-template>
  </xsl:variable>
  <img src="{$PAGE_WEB_PATH}{$src}" class="glyph16" alt=""/>
</xsl:template>

<xsl:template name="panel-info-button">
  <xsl:param name="text"></xsl:param>
  <xsl:param name="mode">info</xsl:param>
  <xsl:param name="href">#</xsl:param>
  <xsl:choose>
    <xsl:when test="($text != '') and ($href != '')">
      <a href="{$href}" tabindex="10000">
        <xsl:attribute name="title"><xsl:value-of select="$text"/></xsl:attribute>
        <xsl:choose>
          <xsl:when test="$mode='error'">
            <img src="{$PAGE_WEB_PATH}icon.status.dialog-error?size=16" class="glyph16" alt="{$text}" />
          </xsl:when>
          <xsl:when test="$mode='help'">
            <img src="{$PAGE_WEB_PATH}icon.status.dialog-help?size=16" class="glyph16" alt="{$text}" />
          </xsl:when>
          <xsl:when test="$mode='needed'">
            <img src="{$PAGE_WEB_PATH}icon.status.dialog-warning?size=16" class="glyph16" alt="{$text}" />
          </xsl:when>
          <xsl:otherwise>
            <img src="{$PAGE_WEB_PATH}icon.status.dialog-information?size=16" class="glyph16" alt="{$text}" />
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$mode='error'">
          <img src="{$PAGE_WEB_PATH}icon.status.dialog-error?size=16" class="glyph16" alt="(!)" />
        </xsl:when>
        <xsl:when test="$mode='help'">
          <img src="{$PAGE_WEB_PATH}icon.status.dialog-help?size=16" class="glyph16" alt="(i)" />
        </xsl:when>
        <xsl:when test="$mode='needed'">
          <img src="{$PAGE_WEB_PATH}icon.status.dialog-warning?size=16" class="glyph16" alt="(*)" />
        </xsl:when>
        <xsl:when test="$mode='minimize'">
          <a href="{$href}" tabindex="10000"><img src="{$PAGE_WEB_PATH}icon.actions.list-remove?size=16" class="glyph16" alt="-" /></a>
        </xsl:when>
        <xsl:when test="$mode='maximize'">
          <a href="{$href}" tabindex="10000"><img src="{$PAGE_WEB_PATH}icon.actions.list-add?size=16" class="glyph16" alt="+" /></a>
        </xsl:when>
        <xsl:otherwise>
          <img src="{$PAGE_WEB_PATH}icon.status.dialog-information?size=16" class="glyph16" alt="{$text}" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
