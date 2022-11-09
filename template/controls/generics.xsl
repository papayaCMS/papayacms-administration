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

<xsl:template name="float-fix">
  <xsl:param name="width"/>
  <div class="fixFloat">
    <xsl:if test="$width and ($width != '') and ($width != '100%')">
      <xsl:attribute name="style">width: <xsl:value-of select="$width"/>;</xsl:attribute>
    </xsl:if>
    <xsl:text> </xsl:text>
  </div>
</xsl:template>

<xsl:template name="replace-string">
  <xsl:param name="subject"/>
  <xsl:param name="search-for"/>
  <xsl:param name="replace-with"/>
  <xsl:choose>
    <xsl:when test="contains($subject, $search-for)">
      <xsl:value-of select="substring-before($subject, $search-for)" />
      <xsl:value-of select="$replace-with" />
      <xsl:call-template name="replace-string">
        <xsl:with-param name="subject" select="substring-after($subject, $search-for)" />
        <xsl:with-param name="search-for" select="$search-for" />
        <xsl:with-param name="replace-with" select="$replace-with" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise><xsl:value-of select="$subject" /></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="escape-quotes-js">
  <xsl:param name="string"/>
  <xsl:call-template name="replace-string">
    <xsl:with-param name="subject" select="$string"/>
    <xsl:with-param name="search-for">"</xsl:with-param>
    <xsl:with-param name="replace-with">\"</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="a">
  <a>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates />
  </a>
</xsl:template>

<xsl:template match="i">
  <i><xsl:apply-templates /></i>
</xsl:template>

<xsl:template match="b">
  <b><xsl:apply-templates /></b>
</xsl:template>

<xsl:template match="br">
  <br/>
</xsl:template>

<xsl:template match="div|p">
  <xsl:element name="{local-name()}">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates />
  </xsl:element>
</xsl:template>

<xsl:template match="span">
  <span>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates />
  </span>
</xsl:template>

<xsl:template match="img">
  <img>
    <xsl:copy-of select="@*"/>
  </img>
</xsl:template>

<xsl:template match="script">
  <script type="{@type}">
    <xsl:comment>
      <xsl:copy-of select="text()"/>
    //</xsl:comment>
  </script>
</xsl:template>

<xsl:template match="noscript">
  <noscript>
    <xsl:apply-templates />
  </noscript>
</xsl:template>

<xsl:template match="object">
  <xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="input[@type='checkbox']">
  <xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="input[@type='radio']">
  <xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="glyphs">
  <span class="glyphGroup">
    <xsl:for-each select="glyph">
      <xsl:call-template name="glyph">
        <xsl:with-param name="glyph" select="." />
      </xsl:call-template>
    </xsl:for-each>
  </span>
</xsl:template>

<xsl:template match="glyph">
  <xsl:call-template name="glyph">
    <xsl:with-param name="glyph" select="."/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="glyph">
  <xsl:param name="glyph"/>
  <xsl:param name="icon-size">
    <xsl:choose>
      <xsl:when test="$glyph/@size"><xsl:value-of select="$glyph/@size"/></xsl:when>
      <xsl:otherwise>16</xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:variable name="src">
    <xsl:call-template name="icon-url">
      <xsl:with-param name="icon-src" select="$glyph/@src"/>
      <xsl:with-param name="icon-size" select="$icon-size"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="image">
    <img src="{$PAGE_WEB_PATH}{$src}" class="glyph{$icon-size}" title="{$glyph/@hint}" alt="{$glyph/@hint}">
      <xsl:if test="$glyph/@id">
        <xsl:attribute name="id"><xsl:value-of select="$glyph/@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="$glyph/@onclick">
        <xsl:attribute name="onclick"><xsl:value-of select="$glyph/@onclick"/></xsl:attribute>
      </xsl:if>
    </img>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$glyph/@href">
      <a href="{$glyph/@href}"><xsl:copy-of select="$image"/></a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$image"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="icon-url">
  <xsl:param name="icon-src" />
  <xsl:param name="icon-size">16</xsl:param>
  <xsl:choose>
    <xsl:when test="$icon-src = '-' or $icon-src = ''">./pics/tpoint.gif</xsl:when>
    <xsl:when test="starts-with($icon-src, 'icon.')"><xsl:value-of select="$icon-src"/>?size=<xsl:value-of select="$icon-size"/></xsl:when>
    <xsl:when test="(starts-with($icon-src, '/') or starts-with($icon-src, './') or starts-with($icon-src, '../')) and  contains($icon-src, '?')">
      <xsl:value-of select="$icon-src"/>
      <xsl:text>&amp;amp;size=</xsl:text>
      <xsl:value-of select="$icon-size"/>
    </xsl:when>
    <xsl:when test="starts-with($icon-src, '/') or starts-with($icon-src, './') or starts-with($icon-src, '../')">
      <xsl:value-of select="$icon-src"/>
      <xsl:text>?size=</xsl:text>
      <xsl:value-of select="$icon-size"/>
    </xsl:when>
    <xsl:when test="contains($icon-src, '/icon.') or contains($icon-src, '/i18n-icon.')">
      <xsl:value-of select="string($icon-src)"/>
    </xsl:when>
    <xsl:when test="starts-with($icon-src, 'i18n-icon.')">
      <xsl:value-of select="string($icon-src)"/>
    </xsl:when>
    <xsl:when test="starts-with($icon-src, 'http://') or starts-with($icon-src, 'https://')"><xsl:value-of select="$icon-src"/></xsl:when>
    <xsl:when test="starts-with($icon-src, 'extension.')"><xsl:value-of select="$icon-src"/>&amp;size=<xsl:value-of select="$icon-size"/></xsl:when>
    <xsl:when test="starts-with($icon-src, 'module:')">extension.image?module=<xsl:value-of select="substring($icon-src, 8, 32)"/>&amp;src=<xsl:value-of select="substring($icon-src, 41)"/>&amp;size=<xsl:value-of select="$icon-size"/>&amp;behavior=.png</xsl:when>
    <xsl:otherwise>icon.<xsl:value-of select="$icon-src"/>?size=<xsl:value-of select="$icon-size"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- this template takes an object tag for flash and adds ie compatibility and swfobject -->
<xsl:template match="object[@type='application/x-shockwave-flash']">
  <xsl:choose>
    <xsl:when test="local-name(..) != 'object'">
      <xsl:variable name="objectId">
        <xsl:choose>
          <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
          <xsl:otherwise>flash<xsl:value-of select="generate-id(.)"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" id="{$objectId}">
        <xsl:copy-of select="@width" />
        <xsl:copy-of select="@height" />
        <xsl:copy-of select="param" />
        <param name="movie" value="{@data}" />
        <xsl:comment><xsl:text disable-output-escaping="yes">[if !IE]&gt;</xsl:text></xsl:comment>
          <object>
            <xsl:copy-of select="@*[name() != 'version']" />
            <xsl:copy-of select="param" />
            <xsl:comment><xsl:text disable-output-escaping="yes">&lt;![endif]</xsl:text></xsl:comment>
              <xsl:apply-templates select="./*[name() != 'param']|./text()"/>
            <xsl:comment><xsl:text disable-output-escaping="yes">[if !IE]&gt;</xsl:text></xsl:comment>
          </object>
        <xsl:comment><xsl:text disable-output-escaping="yes">&lt;![endif]</xsl:text></xsl:comment>
      </object>
      <xsl:if test="@version">
        <script type="text/javascript"><xsl:comment>
          swfobject.registerObject("<xsl:value-of select="$objectId" />", "<xsl:value-of select="@version" />", "{$PAGE_THEME_PATH}papaya/swfobject/expressInstall.swf");
        //</xsl:comment></script>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:comment><xsl:text disable-output-escaping="yes">[if !IE]&gt;</xsl:text></xsl:comment>
      <object>
        <xsl:copy-of select="@*[name() != 'version']" />
        <xsl:copy-of select="param" />
        <xsl:comment><xsl:text disable-output-escaping="yes">&lt;![endif]</xsl:text></xsl:comment>
          <xsl:apply-templates select="./*[name() != 'param']|./text()"/>
        <xsl:comment><xsl:text disable-output-escaping="yes">[if !IE]&gt;</xsl:text></xsl:comment>
      </object>
      <xsl:comment><xsl:text disable-output-escaping="yes">&lt;![endif]</xsl:text></xsl:comment>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="noescape" mode="allowHTML">
  <xsl:value-of disable-output-escaping="yes" select="." />
</xsl:template>

<xsl:template match="@*|node()" mode="allowHTML">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()" mode="allowHTML" />
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
