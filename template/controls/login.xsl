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

<xsl:template name="login-dialog">
  <xsl:param name="login" select="//login"/>
  <form id="loginDialog" action="{$login/@action}" method="post">
    <xsl:copy-of select="$login/input[@type='hidden']" />
    <xsl:call-template name="panel">
      <xsl:with-param name="title" select="$login/@title"/>
      <xsl:with-param name="data">
        <img src="{$PAGE_WEB_PATH}icon.status.system-locked?size=48" class="dialogIconLarge" alt=""/>
        <div class="fields">
          <xsl:if test="$login/message">
            <div class="message"><xsl:apply-templates select="$login/message/*|$login/message/text()"/></div>
          </xsl:if>
          <xsl:if test="$login/fields/field[@ident='username']">
            <xsl:variable name="fieldId">fieldLoginUsername</xsl:variable>
            <label for="{$fieldId}">
              <xsl:value-of select="$login/fields/field[@ident='username']/@title"/>
            </label>
            <input type="text" id="{$fieldId}" class="dialogInput" name="{$login/fields/field[@ident='username']/@name}" value="{$login/fields/field[@ident='username']/@value}" />
          </xsl:if>
          <xsl:if test="$login/fields/field[@ident='password']">
            <xsl:variable name="fieldId">fieldLoginPassword</xsl:variable>
            <label for="{$fieldId}">
              <xsl:value-of select="$login/fields/field[@ident='password']/@title"/>
            </label>
            <input type="password" id="{$fieldId}" class="dialogInput" name="{$login/fields/field[@ident='password']/@name}" />
          </xsl:if>
          <xsl:if test="$login/fields/field[@ident='password2']">
            <xsl:variable name="fieldId">fieldLoginPasswordRepeat</xsl:variable>
            <label for="{$fieldId}">
              <xsl:value-of select="$login/fields/field[@ident='password2']/@title"/>
            </label>
            <input type="password" id="{$fieldId}" class="dialogInput" name="{$login/fields/field[@ident='password2']/@name}" />
          </xsl:if>
          <div class="buttons">
            <button type="submit"><xsl:value-of select="$login/button/@title"/></button>
          </div>
          <xsl:call-template name="float-fix"/>
          <xsl:if test="$login/hint">
            <xsl:for-each select="$login/hint">
              <div class="hint"><xsl:apply-templates/></div>
            </xsl:for-each>
          </xsl:if>
        </div>
        <xsl:call-template name="float-fix"/>
      </xsl:with-param>
    </xsl:call-template>
  </form>
</xsl:template>

</xsl:stylesheet>
