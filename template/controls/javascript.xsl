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

<xsl:variable name="FORM_FIELDS" select="//input|//textarea|//select"/>

<xsl:variable
  name="HAS_CONTROLS_RICHTEXT"
  select="count($FORM_FIELDS[contains(concat(' ', normalize-space(@class), ' '), ' dialogRichtext ')]) &gt; 0"/>

<xsl:variable
  name="HAS_CONTROLS_SIMPLERICHTEXT"
  select="count($FORM_FIELDS[contains(concat(' ', normalize-space(@class), ' '), ' dialogSimpleRichtext ')]) &gt; 0"/>

<xsl:variable
  name="HAS_CONTROLS_INDIVIDUALRICHTEXT"
  select="count($FORM_FIELDS[contains(concat(' ', normalize-space(@class), ' '), ' dialogIndividualRichtext ')]) &gt; 0"/>
  
<xsl:variable name="HAS_RTE" select="$FORM_FIELDS[@data-rte]"/>

<xsl:variable name="EMBED_TINYMCE" select="$HAS_RTE or $HAS_CONTROLS_RICHTEXT or $HAS_CONTROLS_SIMPLERICHTEXT or $HAS_CONTROLS_INDIVIDUALRICHTEXT" />

<xsl:variable name="EMBED_JQUERY" select="true()" />

</xsl:stylesheet>
