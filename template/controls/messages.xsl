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

<xsl:param name="PAPAYA_UI_LANGUAGE"></xsl:param>

<xsl:template name="messages">
  <xsl:param name="messages" select="messages/msg|messages/message"/>
  <xsl:choose>
    <xsl:when test="count($messages) = 1">
      <xsl:variable name="title">
        <xsl:call-template name="message-caption">
          <xsl:with-param name="message-severity" select="$messages[1]/@type" />
        </xsl:call-template>
      </xsl:variable>
      <div class="panel">
        <h2 class="panelHeader"><xsl:value-of select="$title"/></h2>
        <div class="panelBody">
          <div class="dialogImage">
            <xsl:variable name="severity" select="$messages[1]/@severity|$messages[1]/@type"/>
            <xsl:variable name="image">
              <xsl:choose>
                <xsl:when test="$severity = 'warning'">status/dialog-warning.png</xsl:when>
                <xsl:when test="$severity = 'error'">status/dialog-error.png</xsl:when>
                <xsl:otherwise>status/dialog-information.png</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <img class="glyph48" src="pics/icons/48x48/{$image}" alt="" />
          </div>
          <div class="dialogText">
             <xsl:value-of select="$messages[1]/text()" disable-output-escaping="yes" />
          </div>
          <xsl:call-template name="float-fix" />
        </div>
      </div>
    </xsl:when>
    <xsl:when test="count($messages) &gt; 1">
      <div class="panel">
        <h2 class="panelHeader">
          <xsl:call-template name="translate-phrase">
            <xsl:with-param name="phrase">Messages</xsl:with-param>
          </xsl:call-template>
        </h2>
        <div class="panelBody">
          <table class="listview">
            <xsl:for-each select="$messages">
              <tr>
                <xsl:attribute name="class">
                  <xsl:choose>
                    <xsl:when test="@selected">selected</xsl:when>
                    <xsl:when test="not(position() mod 2)">even</xsl:when>
                    <xsl:otherwise>odd</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <td>
                  <xsl:variable name="severity" select="$messages[1]/@severity|$messages[1]/@type"/>
                  <xsl:variable name="image">
                    <xsl:choose>
                      <xsl:when test="$severity = 'warning'">status/dialog-warning.png</xsl:when>
                      <xsl:when test="$severity = 'error'">status/dialog-error.png</xsl:when>
                      <xsl:otherwise>status/dialog-information.png</xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  <span class="itemIcon"><img class="glyph48" src="pics/icons/16x16/{$image}"/></span>
                  <span class="itemTitle"><xsl:value-of select="text()" disable-output-escaping="yes" /></span>
                </td>
              </tr>
            </xsl:for-each>
          </table>
        </div>
      </div>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template name="message-dialog">
  <xsl:param name="dialog" />
  <xsl:variable name="title">
    <xsl:call-template name="message-caption">
      <xsl:with-param name="message-severity" select="$dialog/@type" />
    </xsl:call-template>
  </xsl:variable>
  <div class="panel">
    <h2 class="panelHeader"><xsl:value-of select="$title"/></h2>
    <div class="panelBody">
      <form action="{$dialog/@action}" method="post">
        <xsl:if test="$dialog/@action and $dialog/@action != ''">
          <xsl:attribute name="action"><xsl:value-of select="$dialog/@action"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="$dialog/@onsubmit and $dialog/@onsubmit != ''">
          <xsl:attribute name="onsubmit"><xsl:value-of select="$dialog/@onsubmit"/></xsl:attribute>
        </xsl:if>
        <xsl:copy-of select="$dialog/input[@type = 'hidden']"/>
        <div class="dialogImage">
          <xsl:variable name="image">
            <xsl:choose>
              <xsl:when test="$dialog/@type = 'warning'">status/dialog-warning.png</xsl:when>
              <xsl:when test="$dialog/@type = 'error'">status/dialog-error.png</xsl:when>
              <xsl:when test="$dialog/@type = 'question'">status/dialog-confirmation.png</xsl:when>
              <xsl:otherwise>status/dialog-information.png</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <img class="glyph48" src="pics/icons/48x48/{$image}" alt=""/>
        </div>
        <div class="dialogText">
           <xsl:value-of select="$dialog/message/text()" />
        </div>
        <xsl:call-template name="old-dialog-buttons">
          <xsl:with-param name="buttons" select="$dialog/dlgbutton"/>
        </xsl:call-template>
      </form>
      <xsl:call-template name="float-fix"/>
    </div>
  </div>
</xsl:template>

<xsl:template name="message-caption">
  <xsl:param name="message-severity">info</xsl:param>
  <xsl:call-template name="translate-phrase">
    <xsl:with-param name="phrase">
      <xsl:choose>
        <xsl:when test="$message-severity = 'question'">Question</xsl:when>
        <xsl:when test="$message-severity = 'warning'">Warning</xsl:when>
        <xsl:when test="$message-severity = 'error'">Error</xsl:when>
        <xsl:otherwise>Information</xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>


<xsl:template name="translate-phrase">
  <xsl:param name="phrase" />
  <xsl:variable name="lngFile">
    <xsl:choose>
      <xsl:when test="$PAPAYA_UI_LANGUAGE = 'de-DE'">../lang/de.xml</xsl:when>
      <xsl:otherwise>../lang/en.xml</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$lngFile != ''">
      <xsl:variable name="phrases" select="document($lngFile)"/>
      <xsl:choose>
        <xsl:when test="$phrases/phrases/phrase[@ident = $phrase]/text() != ''">
          <xsl:value-of select="$phrases/phrases/phrase[@ident = $phrase]" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$phrase" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$phrase" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="msgdialog">
  <xsl:call-template name="message-dialog">
    <xsl:with-param name="dialog" select="."/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
