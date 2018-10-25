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

<xsl:template name="calendar-monthly-small">
  <xsl:param name="calendar"/>
  <div class="panel">
    <table class="monthCalendar">
      <thead>
        <th>
          <a href="{$calendar/monthnav/month[@position = 'prior']/@href}" title="{$calendar/monthnav/month[@position = 'prior']/@hint}"><img src="{$PAPAYA_PATH_SKIN}/pics/prior.png" alt="" style="width: 6px; height: 10px; border: none;" /></a>
        </th>
        <th colspan="6">
          <xsl:value-of select="$calendar/monthnav/month[@position = 'actual']/@title"/><xsl:text> </xsl:text><xsl:value-of select="$calendar/monthnav/month[@position = 'actual']/@year" />
        </th>
        <th>
          <a href="{$calendar/monthnav/month[@position = 'next']/@href}" title="{$calendar/monthnav/month[@position = 'next']/@hint}"><img src="{$PAPAYA_PATH_SKIN}/pics/next.png" alt="" style="width: 6px; height: 10px; border: none;" /></a>
        </th>
        <tr class="weekDays">
          <th><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></th>
          <xsl:for-each select="$calendar/weekdays/wday">
            <th><xsl:value-of select="@title"/></th>
          </xsl:for-each>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select="$calendar/weeks/week">
          <tr>
            <th><xsl:value-of select="@no"/></th>
            <xsl:for-each select="day">
              <td>
                <xsl:choose>
                  <xsl:when test="@selected">
                    <xsl:attribute name="class">selected</xsl:attribute>
                  </xsl:when>
                  <xsl:when test="@type = 'filled'">
                    <xsl:attribute name="class">filled</xsl:attribute>
                  </xsl:when>
                </xsl:choose>
                <xsl:if test="@dayspan">
                  <xsl:attribute name="colspan"><xsl:value-of select="@dayspan"/></xsl:attribute>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="@type = 'spacer'"><xsl:text> </xsl:text></xsl:when>
                  <xsl:otherwise>
                    <a href="{@href}"><xsl:value-of select="text()"/></a>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
            </xsl:for-each>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </div>
</xsl:template>

<xsl:template match="monthcalendar">
  <xsl:call-template name="calendar-monthly-small">
    <xsl:with-param name="calendar" select="."/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
