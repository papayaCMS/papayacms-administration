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
  xmlns:papaya-fn="http://www.papaya-cms.com/ns/functions"
  exclude-result-prefixes="papaya-fn">

  <xsl:import href="../_functions/json-encode.xsl"/>
  <xsl:import href="./dialogs-old.xsl"/>
  <xsl:import href="./sheet.xsl"/>

  <xsl:variable name="DIALOG_CAPTION_STYLE_NONE" select="0"/>
  <xsl:variable name="DIALOG_CAPTION_STYLE_SIDE" select="1"/>
  <xsl:variable name="DIALOG_CAPTION_STYLE_TOP" select="2"/>

  <xsl:variable name="DIALOG_SIZE_XS" select="'xs'"/>
  <xsl:variable name="DIALOG_SIZE_S" select="'s'"/>
  <xsl:variable name="DIALOG_SIZE_M" select="'m'"/>
  <xsl:variable name="DIALOG_SIZE_L" select="'l'"/>

  <xsl:param name="PAGE_WEB_PATH">./</xsl:param>

  <xsl:template match="dialog-box">
    <xsl:call-template name="dialog-box">
      <xsl:with-param name="dialog" select="." />
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="dialog-box">
    <xsl:param name="dialog"/>
    <form method="post">
      <xsl:attribute name="action">
        <xsl:call-template name="dialog-action">
          <xsl:with-param name="dialog" select="$dialog"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="method">
        <xsl:choose>
          <xsl:when test="$dialog/@method = 'get'">get</xsl:when>
          <xsl:otherwise>post</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="$dialog/@enctype">
        <xsl:attribute name="enctype"><xsl:value-of select="@enctype"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="$dialog/@id">
        <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="$dialog/@onsubmit">
        <xsl:attribute name="onsubmit"><xsl:value-of select="@onsubmit"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="$dialog/@target">
        <xsl:attribute name="target"><xsl:value-of select="@target"/></xsl:attribute>
      </xsl:if>
      <xsl:attribute name="class">
        <xsl:text>dialog</xsl:text>
        <xsl:choose>
          <xsl:when test="$dialog/options/option[@name = 'DIALOG_WIDTH']/@value = $DIALOG_SIZE_M">
            <xsl:text> dialogSizeMedium</xsl:text>
          </xsl:when>
          <xsl:when test="$dialog/options/option[@name = 'DIALOG_WIDTH']/@value = $DIALOG_SIZE_XS">
            <xsl:text> dialogSizeXSmall</xsl:text>
          </xsl:when>
          <xsl:when test="$dialog/options/option[@name = 'DIALOG_WIDTH']/@value = $DIALOG_SIZE_S">
            <xsl:text> dialogSizeSmall</xsl:text>
          </xsl:when>
          <xsl:when test="$dialog/options/option[@name = 'DIALOG_WIDTH']/@value = $DIALOG_SIZE_L">
            <xsl:text> dialogSizeLarge</xsl:text>
          </xsl:when>
        </xsl:choose>
        <xsl:if test="$dialog/options/option[@name = 'PROTECT_CHANGES']/@value = 'yes'">
          <xsl:text> dialogProtectChanges</xsl:text>
        </xsl:if>
      </xsl:attribute>
      <xsl:call-template name="dialog-scripts">
        <xsl:with-param name="dialog" select="$dialog"/>
      </xsl:call-template>
      <xsl:call-template name="dialog-parameters">
        <xsl:with-param name="dialog" select="$dialog"/>
      </xsl:call-template>
      <div class="panel">
        <xsl:call-template name="dialog-title">
          <xsl:with-param name="dialog" select="$dialog"/>
        </xsl:call-template>
        <div class="panelBody">
          <xsl:call-template name="dialog-buttons">
            <xsl:with-param name="dialog" select="$dialog"/>
            <xsl:with-param name="show" select="$dialog/options/option[@name = 'TOP_BUTTONS']/@value = 'yes'"/>
            <xsl:with-param name="position">TOP</xsl:with-param>
          </xsl:call-template>
          <table class="dialog">
            <xsl:call-template name="dialog-fields">
              <xsl:with-param name="dialog" select="$dialog"/>
            </xsl:call-template>
          </table>
          <xsl:call-template name="dialog-buttons">
            <xsl:with-param name="dialog" select="$dialog"/>
            <xsl:with-param name="show" select="$dialog/options/option[@name = 'BOTTOM_BUTTONS']/@value = 'yes'"/>
          </xsl:call-template>
        </div>
      </div>
    </form>
  </xsl:template>

  <xsl:template name="dialog-action">
    <xsl:param name="dialog"/>
    <xsl:choose>
      <xsl:when test="$dialog/@id and not(contains($dialog/@action, '#') or starts-with($dialog/@action, 'javascript:'))">
        <xsl:value-of select="$dialog/@action"/>
        <xsl:text>#</xsl:text>
        <xsl:value-of select="$dialog/@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$dialog/@action"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="dialog-parameters">
    <xsl:param name="dialog"/>
    <xsl:copy-of select="$dialog/input[@type='hidden']"/>
  </xsl:template>

  <xsl:template name="dialog-scripts">
    <xsl:param name="dialog"/>
    <!--  @todo output javascripts for a dialog -->
  </xsl:template>

  <xsl:template name="dialog-title">
    <xsl:param name="dialog"/>
    <xsl:param name="title" select="$dialog/title"/>
    <xsl:if test="$title and $title/@caption != ''">
      <h2 class="panelHeader">
        <xsl:if test="$dialog/title/@icon">
          <span class="panelIcon">
            <xsl:call-template name="panel-icon">
              <xsl:with-param name="icon" select="$dialog/title/@icon" />
            </xsl:call-template>
          </span>
        </xsl:if>
        <xsl:value-of select="$title/@caption"/>
      </h2>
    </xsl:if>
  </xsl:template>

  <xsl:template name="dialog-buttons">
    <xsl:param name="dialog"/>
    <xsl:param name="show" select="true()"/>
    <xsl:param name="position">BOTTOM</xsl:param>
    <xsl:if test="$show and $dialog/button">
      <div>
        <xsl:attribute name="class">
          <xsl:choose>
            <xsl:when test="$position = 'TOP'">buttons buttonsTop</xsl:when>
            <xsl:otherwise>buttons buttonsBottom</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <div class="buttonsArtWork">
          <xsl:for-each select="$dialog/button[not(@align) or (@align != 'left')]">
            <xsl:call-template name="dialog-button">
              <xsl:with-param name="button" select="."/>
            </xsl:call-template>
          </xsl:for-each>
          <xsl:for-each select="$dialog/button[@align = 'left']">
            <xsl:call-template name="dialog-button">
              <xsl:with-param name="button" select="."/>
            </xsl:call-template>
          </xsl:for-each>
          <xsl:call-template name="float-fix" />
        </div>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template name="dialog-button">
    <xsl:param name="button"/>
    <xsl:variable name="hasImage" select="$button/@image and $button/@image != ''"/>
    <xsl:choose>
      <xsl:when test="$button/@type = 'image'">
      </xsl:when>
      <xsl:when test="$button/@type = 'link'">
        <a href="{@href}">
          <xsl:if test="$button/@id != ''">
            <xsl:attribute name="id"><xsl:value-of select="$button/@id"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="$button/@hint != ''">
            <xsl:attribute name="title"><xsl:value-of select="$button/@hint"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="$button/@onclick != ''">
            <xsl:attribute name="onclick"><xsl:value-of select="$button/@onclick"/></xsl:attribute>
          </xsl:if>
          <xsl:attribute name="class">
            <xsl:text>button </xsl:text>
            <xsl:choose>
              <xsl:when test="@align = 'left'">left</xsl:when>
              <xsl:otherwise>right</xsl:otherwise>
            </xsl:choose>
            <xsl:if test="$hasImage"><xsl:text> buttonWithImage</xsl:text></xsl:if>
          </xsl:attribute>
          <xsl:if test="$hasImage">
            <xsl:attribute name="style">background-image: url(<xsl:value-of select="$button/@image"/>)</xsl:attribute>
          </xsl:if>
          <xsl:value-of select="$button/text()"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <input>
          <xsl:attribute name="type">
            <xsl:choose>
              <xsl:when test="$button/@type"><xsl:value-of select="$button/@type"/></xsl:when>
              <xsl:otherwise>submit</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:if test="$button/@name != ''">
            <xsl:attribute name="name"><xsl:value-of select="$button/@name"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="$button/@id != ''">
            <xsl:attribute name="id"><xsl:value-of select="$button/@id"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="$button/@hint != ''">
            <xsl:attribute name="title"><xsl:value-of select="$button/@hint"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="$button/@onclick != ''">
            <xsl:attribute name="onclick"><xsl:value-of select="$button/@onclick"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="$button/text() != ''">
            <xsl:attribute name="value"><xsl:value-of select="$button/text()"/></xsl:attribute>
          </xsl:if>
          <xsl:attribute name="class">
            <xsl:text>button </xsl:text>
            <xsl:choose>
              <xsl:when test="@align = 'left'">left</xsl:when>
              <xsl:otherwise>right</xsl:otherwise>
            </xsl:choose>
            <xsl:if test="$hasImage"><xsl:text> buttonWithImage</xsl:text></xsl:if>
          </xsl:attribute>
          <xsl:if test="$hasImage">
            <xsl:attribute name="style">background-image: url(<xsl:value-of select="$button/@image"/>)</xsl:attribute>
          </xsl:if>
        </input>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="dialog-fields">
    <xsl:param name="dialog"/>
    <xsl:param name="fields" select="$dialog/field|$dialog/field-group"/>
    <xsl:for-each select="$fields">
      <xsl:choose>
        <xsl:when test="name() = 'field-group'">
          <xsl:call-template name="dialog-field-group">
            <xsl:with-param name="dialog" select="$dialog"/>
            <xsl:with-param name="group" select="." />
            <xsl:with-param name="position" select="position()" />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="dialog-field">
            <xsl:with-param name="dialog" select="$dialog"/>
            <xsl:with-param name="field" select="."/>
            <xsl:with-param name="position" select="position()" />
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="dialog-field">
    <xsl:param name="dialog"/>
    <xsl:param name="field"/>
    <xsl:param name="position"/>
    <xsl:variable name="options" select="$dialog/options/option"/>
    <xsl:variable name="hasCaption" select="$field/@caption and $field/@caption != ''"/>
    <xsl:variable name="hasHint" select="$field/@hint and $field/@hint != ''"/>
    <xsl:variable name="captionsPosition" select="$options[@name = 'CAPTION_STYLE']/@value"/>
    <xsl:variable
        name="span"
        select="not($hasCaption) or (@span = 'yes' and $captionsPosition = $DIALOG_CAPTION_STYLE_SIDE)"
    />
    <xsl:variable name="rowClass">
      <xsl:choose>
        <xsl:when test="not($position mod 2)">even</xsl:when>
        <xsl:otherwise>odd</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$captionsPosition = $DIALOG_CAPTION_STYLE_TOP">
      <tr class="{$rowClass}">
        <xsl:call-template name="dialog-field-caption">
          <xsl:with-param name="field" select="$field" />
        </xsl:call-template>
      </tr>
    </xsl:if>
    <xsl:if test="$hasHint">
      <tr class="{$rowClass}">
        <xsl:if test="$captionsPosition = $DIALOG_CAPTION_STYLE_SIDE and not($span)">
          <xsl:call-template name="dialog-field-caption">
            <xsl:with-param name="field" select="$field" />
            <xsl:with-param name="spanForHint" select="true()" />
          </xsl:call-template>
        </xsl:if>
        <td class="hint" id="hint{generate-id($field)}">
          <div class="hintText"><xsl:value-of select="$field/@hint"/></div>
        </td>
      </tr>
    </xsl:if>
    <tr class="{$rowClass}">
      <xsl:if test="not($span) and not($hasHint) and $captionsPosition = $DIALOG_CAPTION_STYLE_SIDE">
        <xsl:call-template name="dialog-field-caption">
          <xsl:with-param name="field" select="$field" />
        </xsl:call-template>
      </xsl:if>
      <td>
        <xsl:if test="$span">
          <xsl:attribute name="colspan">2</xsl:attribute>
        </xsl:if>
        <xsl:attribute name="class">
          <xsl:text>element</xsl:text>
          <xsl:if test="$field/@error = 'yes'">
            <xsl:text> error</xsl:text>
          </xsl:if>
        </xsl:attribute>
        <xsl:choose>
          <xsl:when test="$field/group">
            <xsl:call-template name="dialog-field-grouped">
              <xsl:with-param name="field" select="$field"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$field/select">
            <xsl:call-template name="dialog-field-select">
              <xsl:with-param name="field" select="$field"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$field/textarea">
            <xsl:call-template name="dialog-field-textarea">
              <xsl:with-param name="field" select="$field"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$field/input[@type='checkbox']">
            <xsl:call-template name="dialog-field-input-checkbox">
              <xsl:with-param name="field" select="$field"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$field/input[@type='file']">
            <xsl:call-template name="dialog-field-input-file">
              <xsl:with-param name="field" select="$field"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$field/input">
            <xsl:call-template name="dialog-field-input">
              <xsl:with-param name="field" select="$field"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$field/message">
            <xsl:call-template name="dialog-field-message">
              <xsl:with-param name="field" select="$field"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$field/buttons/button">
            <xsl:call-template name="dialog-field-buttons">
              <xsl:with-param name="field" select="$field"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$field/listview">
            <xsl:call-template name="dialog-field-listview">
              <xsl:with-param name="field" select="$field"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$field/sheet">
            <xsl:call-template name="dialog-field-sheet">
              <xsl:with-param name="field" select="$field"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$field/image">
            <xsl:call-template name="dialog-field-image">
              <xsl:with-param name="field" select="$field"/>
            </xsl:call-template>
          </xsl:when>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>

  <xsl:template name="dialog-field-caption">
    <xsl:param name="field"/>
    <xsl:param name="spanForHint" select="false()"/>
    <xsl:variable name="caption">
      <xsl:choose>
        <xsl:when test="$field/input[@type='checkbox']"></xsl:when>
        <xsl:otherwise>
          <span class="text"><xsl:value-of select="$field/@caption"/></span>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <td>
      <xsl:attribute name="class">
        <xsl:text>caption</xsl:text>
        <xsl:if test="$field/@mandatory = 'yes'">
          <xsl:text> mandatory</xsl:text>
        </xsl:if>
      </xsl:attribute>
      <xsl:if test="$spanForHint">
        <xsl:attribute name="rowspan">2</xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test=" $field/@hint != '' and $field/@error = 'yes'">
          <a href="#hint{generate-id($field)}" class="hintSwitch">
            <img src="{$PAGE_WEB_PATH}icon.status.dialog-error?size=16" class="hintMarker errorMarker" alt=""/>
            <xsl:copy-of select="$caption"/>
          </a>
        </xsl:when>
        <xsl:when test="$field/@hint != ''">
          <a href="#hint{generate-id($field)}" class="hintSwitch">
            <img src="{$PAGE_WEB_PATH}icon.status.dialog-information?size=16" alt="" class="hintMarker"/>
            <xsl:copy-of select="$caption"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$field/@error = 'yes'">
            <img src="{$PAGE_WEB_PATH}icon.status.dialog-error?size=16" class="hintMarker errorMarker" alt=""/>
          </xsl:if>
          <xsl:copy-of select="$caption"/>
        </xsl:otherwise>
      </xsl:choose>
    </td>
  </xsl:template>

  <xsl:template name="dialog-field-group">
    <xsl:param name="dialog"/>
    <xsl:param name="group"/>
    <xsl:param name="position"/>
    <xsl:if test="$group/@caption and $group/@caption != ''">
      <tr>
        <th colspan="3" class="subtitle"><xsl:value-of select="$group/@caption"/></th>
      </tr>
    </xsl:if>
    <xsl:call-template name="dialog-fields">
      <xsl:with-param name="dialog" select="$dialog"/>
      <xsl:with-param name="fields" select="$group/field|$group/field-group"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="dialog-field-grouped">
    <xsl:param name="field"/>
    <div>
      <xsl:copy-of select="$field/group/@*[starts-with(local-name(), 'data-')]"/>
      <xsl:attribute name="class">
        <xsl:text>group</xsl:text>
        <xsl:choose>
          <xsl:when test="$field/@class = 'DialogFieldDateRange'"><xsl:text> dialogInputDateRange</xsl:text></xsl:when>
        </xsl:choose>
      </xsl:attribute>
      <xsl:variable name="labels">
        <xsl:for-each select="$field/group/labels/label">
           <xsl:element name="{@for}"><xsl:value-of select="."/></xsl:element>
        </xsl:for-each>
      </xsl:variable>
      <xsl:attribute name="data-labels">
        <xsl:value-of select="papaya-fn:json-encode($labels)"/>
      </xsl:attribute>
      <xsl:for-each select="$field/group/*">
        <xsl:choose>
          <xsl:when test="local-name(.) = 'input'">
            <xsl:call-template name="dialog-field-input">
              <xsl:with-param name="field" select="$field"/>
              <xsl:with-param name="input" select="."/>
            </xsl:call-template>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </div>
  </xsl:template>

  <!--
    Dialog Field: message

    Message text

    Attributes:
      image - message image name
  -->
  <xsl:template name="dialog-field-message">
    <xsl:param name="field"/>
    <xsl:param name="message" select="$field/message"/>
    <xsl:variable name="icon">
      <xsl:call-template name="icon-url">
        <xsl:with-param name="icon-src" select="$field/message/@image"/>
        <xsl:with-param name="icon-size">48</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <div class="dialogMessage">
      <xsl:if test="$field/message/@image">
        <img class="dialogMessageImage" src="{$PAGE_WEB_PATH}{$icon}" alt=""/>
      </xsl:if>
      <div class="message">
        <xsl:value-of select="$message/node()"/>
      </div>
      <xsl:call-template name="float-fix"/>
    </div>
  </xsl:template>

  <!--
    Dialog Field: buttons

    Buttons list
  -->
  <xsl:template name="dialog-field-buttons">
    <xsl:param name="field"/>
    <xsl:param name="buttons" select="$field/buttons/button"/>
    <xsl:if test="$buttons and count($buttons) &gt; 0">
      <div class="buttons">
        <xsl:for-each select="$buttons[not(@align) or (@align != 'left')]">
          <xsl:call-template name="dialog-button">
            <xsl:with-param name="button" select="."/>
          </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select="$buttons[@align = 'left']">
          <xsl:call-template name="dialog-button">
            <xsl:with-param name="button" select="."/>
          </xsl:call-template>
        </xsl:for-each>
        <xsl:call-template name="float-fix" />
      </div>
    </xsl:if>
  </xsl:template>

  <!--
    Dialog Field: ListView
  -->
  <xsl:template name="dialog-field-listview">
    <xsl:param name="field"/>
    <xsl:param name="listview" select="$field/listview"/>
    <div class="dialogListview">
      <xsl:call-template name="listview">
        <xsl:with-param name="listview" select="$listview"/>
      </xsl:call-template>
    </div>
  </xsl:template>

  <!--
    Dialog Field: ListView
  -->
  <xsl:template name="dialog-field-sheet">
    <xsl:param name="field"/>
    <xsl:param name="sheet" select="$field/sheet"/>
    <div class="dialogSheet">
      <xsl:call-template name="sheet">
        <xsl:with-param name="sheet" select="$sheet"/>
      </xsl:call-template>
    </div>
  </xsl:template>

  <!--
    Dialog Field: input

    Single line text input field

    Attributes:
      name - field name
      maxlength - maximum char length
      type - subtype
  -->
  <xsl:template name="dialog-field-input">
    <xsl:param name="field"/>
    <xsl:param name="input" select="$field/input"/>
    <xsl:if test="$input/@type = 'captcha' and $field/image">
      <div class="captchaDisplay">
        <img src="{$PAGE_WEB_PATH}{$field/image/@src}" alt=""/>
      </div>
    </xsl:if>
    <input name="{$input/@name}">
      <xsl:attribute name="type">
        <xsl:choose>
          <xsl:when test="$input/@type = 'password'">password</xsl:when>
          <xsl:when test="$input/@type = 'email'">email</xsl:when>
          <xsl:otherwise>text</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="$input/@maxlength &gt; 0">
        <xsl:attribute name="maxlength">
          <xsl:value-of select="$input/@maxlength"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$field/@disabled = 'yes'">
        <xsl:attribute name="disabled">disabled</xsl:attribute>
      </xsl:if>
      <xsl:attribute name="class">
        <xsl:text>scaleable dialogInput</xsl:text>
        <xsl:if test="$field/@disabled = 'yes'">
          <xsl:text> dialogDisabled</xsl:text>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="$input/@type = 'captcha'"><xsl:text> dialogInputCaptcha</xsl:text></xsl:when>
          <xsl:when test="$input/@type = 'color'"><xsl:text> dialogInputColor</xsl:text></xsl:when>
          <xsl:when test="$input/@type = 'counted'"><xsl:text> dialogInputCounted</xsl:text></xsl:when>
          <xsl:when test="$input/@type = 'date'"><xsl:text> dialogInputDate</xsl:text></xsl:when>
          <xsl:when test="$input/@type = 'datetime'"><xsl:text> dialogInputDateTime</xsl:text></xsl:when>
          <xsl:when test="$input/@type = 'email'"><xsl:text> dialogInputEmail</xsl:text></xsl:when>
          <xsl:when test="$input/@type = 'geoposition'"><xsl:text> dialogInputGeoPosition</xsl:text></xsl:when>
          <xsl:when test="$input/@type = 'media_file'"><xsl:text> dialogInputMediaFile</xsl:text></xsl:when>
          <xsl:when test="$input/@type = 'media_image'"><xsl:text> dialogInputMediaImage</xsl:text></xsl:when>
          <xsl:when test="$input/@type = 'media_image_resized'"><xsl:text> dialogInputMediaImageResized</xsl:text></xsl:when>
          <xsl:when test="$input/@type = 'page'"><xsl:text> dialogInputPage</xsl:text></xsl:when>
          <xsl:when test="$input/@type = 'suggest'"><xsl:text> dialogInputSuggest</xsl:text></xsl:when>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="$field/@disabled">
        <xsl:attribute name="disabled">disabled</xsl:attribute>
      </xsl:if>
      <xsl:copy-of select="$input/@*[starts-with(name(), 'data-')]"/>
      <xsl:if test="$input/node()">
        <xsl:attribute name="value"><xsl:value-of select="$input/node()"/></xsl:attribute>
      </xsl:if>
    </input>
  </xsl:template>

  <!--
    Dialog Field: input-checkbox

    Single line text input field

    Attributes:
      name - field name
      type - subtype
      value - value
  -->
  <xsl:template name="dialog-field-input-checkbox">
    <xsl:param name="field"/>
    <xsl:param name="input" select="$field/input"/>
    <xsl:param name="id" select="generate-id($input)"/>
    <input name="{$input/@name}" type="checkbox" class="dialogCheckbox" id="{$id}">
      <xsl:copy-of select="$input/@*[starts-with(name(), 'data-')]"/>
      <xsl:if test="$input/node()">
        <xsl:attribute name="value"><xsl:value-of select="$input/node()"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="$input/@checked">
        <xsl:attribute name="checked">checked</xsl:attribute>
      </xsl:if>
    </input>
    <label for="{$id}"><xsl:value-of select="$field/@caption"/></label>
  </xsl:template>

  <!--
    Dialog Field: input-file

    Single line text input field

    Attributes:
      name - field name
      type - subtype
      value - value
  -->
  <xsl:template name="dialog-field-input-file">
    <xsl:param name="field"/>
    <xsl:param name="input" select="$field/input"/>
    <xsl:param name="id" select="generate-id($input)"/>
    <input name="{$input/@name}" type="file" class="scaleable dialogFileUpload" id="{$id}">
      <xsl:copy-of select="$input/@*[starts-with(name(), 'data-')]"/>
      <xsl:copy-of select="$input/@accept"/>
    </input>
  </xsl:template>

  <!--
    Dialog Field: textarea

    Multiline text/richtext input field

    Attributes:
      name - field name
      lines - line count (rows)
      type - subtype
  -->
  <xsl:template name="dialog-field-textarea">
    <xsl:param name="field"/>
    <xsl:param name="textarea" select="$field/textarea"/>
    <textarea name="{$textarea/@name}" rows="{$textarea/@lines}">
      <xsl:attribute name="class">
        <xsl:text>scaleable </xsl:text>
        <xsl:choose>
          <xsl:when test="$textarea/@data-rte = 'standard'">dialogRichtext</xsl:when>
          <xsl:when test="$textarea/@data-rte = 'simple'">dialogSimpleRichtext</xsl:when>
          <xsl:when test="$textarea/@data-rte = 'individual'">dialogIndividualRichtext</xsl:when>
          <xsl:otherwise>dialogTextarea</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:copy-of select="$textarea/@*[starts-with(name(), 'data-')]"/>
      <xsl:copy-of select="$textarea/node()"/>
    </textarea>
  </xsl:template>

  <!--
    Dialog field: select

    Group of selectable options

    Attributes:
      name - field name
      value - currently selected value
      type - subtype (dropdown, list, radio, checkboxes)

    Child nodes:
      option - selectable option (no allowed of options contains group)
      Attributes:
        selected - status
        value - option value

      group - option group (group contains option elements)
  -->
  <xsl:template name="dialog-field-select">
    <xsl:param name="field"/>
    <xsl:param name="select" select="$field/select"/>
    <xsl:choose>
      <xsl:when test="$select/@type = 'dropdown'">
        <xsl:choose>
          <xsl:when test="count($select/group) &gt; 0">
            <select class="scaleable dialogSelect" name="{$select/@name}" size="1">
              <xsl:for-each select="$select/group">
                <optgroup label="{./@caption}">
                  <xsl:for-each select="./option">
                    <xsl:call-template name="dialog-field-select-option">
                      <xsl:with-param name="option" select="."/>
                    </xsl:call-template>
                  </xsl:for-each>
                </optgroup>
              </xsl:for-each>
            </select>
          </xsl:when>
          <xsl:otherwise>
            <select class="scaleable dialogSelect" name="{$select/@name}" size="1">
              <xsl:for-each select="$select/option">
                <xsl:call-template name="dialog-field-select-option">
                  <xsl:with-param name="option" select="."/>
                </xsl:call-template>
              </xsl:for-each>
            </select>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$select/@type = 'list'">
        <select class="scaleable dialogList" name="{$select/@name}" multiple="multiple">
          <xsl:for-each select="$select/option">
            <xsl:call-template name="dialog-field-select-option">
              <xsl:with-param name="option" select="."/>
            </xsl:call-template>
          </xsl:for-each>
        </select>
      </xsl:when>
      <xsl:when test="$select/@type = 'radio'">
        <div class="dialogRadio">
          <xsl:for-each select="$select/option">
            <xsl:call-template name="dialog-field-select-option-input">
              <xsl:with-param name="option" select="."/>
              <xsl:with-param name="name" select="$select/@name"/>
              <xsl:with-param name="type">radio</xsl:with-param>
            </xsl:call-template>
          </xsl:for-each>
        </div>
      </xsl:when>
      <xsl:when test="$select/@type = 'checkboxes'">
        <div class="dialogCheckboxes">
          <xsl:for-each select="$select/option">
            <xsl:call-template name="dialog-field-select-option-input">
              <xsl:with-param name="option" select="."/>
              <xsl:with-param name="name" select="concat($select/@name, '[]')"/>
              <xsl:with-param name="type">checkbox</xsl:with-param>
            </xsl:call-template>
          </xsl:for-each>
        </div>
      </xsl:when>
    </xsl:choose>
    <!--  implement select, radioboxes, checkboxes -->
  </xsl:template>

  <xsl:template name="dialog-field-select-option">
    <xsl:param name="option"/>
    <option value="{$option/@value}">
      <xsl:if test="$option/@selected">
        <xsl:attribute name="selected">selected</xsl:attribute>
        <xsl:attribute name="class">selected</xsl:attribute>
      </xsl:if>
      <xsl:if test="$option/glyph">
        <xsl:attribute name="data-image"><xsl:value-of select="$option/glyph/@src"/></xsl:attribute>
      </xsl:if>
      <xsl:value-of select="$option/node()"/>
    </option>
  </xsl:template>

  <xsl:template name="dialog-field-select-option-input">
    <xsl:param name="option"/>
    <xsl:param name="name"/>
    <xsl:param name="type"/>
    <div class="option">
      <input type="{$type}" name="{$name}" value="{$option/@value}" id="{generate-id($option)}">
        <xsl:if test="$option/@selected">
          <xsl:attribute name="checked">checked</xsl:attribute>
          <xsl:attribute name="class">selected</xsl:attribute>
        </xsl:if>
      </input>
      <label for="{generate-id($option)}"><xsl:apply-templates select="$option/node()"/></label>
    </div>
  </xsl:template>

  <xsl:template name="dialog-field-image">
    <xsl:param name="field"/>
    <xsl:param name="image" select="$field/image"/>

    <img src="{$PAGE_WEB_PATH}{$image/@src}" alt="" />
  </xsl:template>

</xsl:stylesheet>
