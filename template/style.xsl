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
  xmlns:exslt="http://exslt.org/common"
  extension-element-prefixes="exslt">

<xsl:import href="controls/generics.xsl"/>
<xsl:import href="controls/messages.xsl"/>
<xsl:import href="controls/panel.xsl"/>
<xsl:import href="controls/menus.xsl"/>
<xsl:import href="controls/hierarchy.xsl"/>
<xsl:import href="controls/listview.xsl"/>
<xsl:import href="controls/dialogs.xsl"/>
<xsl:import href="controls/grid.xsl"/>
<xsl:import href="controls/sheet.xsl"/>
<xsl:import href="controls/iconpanel.xsl"/>
<xsl:import href="controls/login.xsl"/>
<xsl:import href="controls/calendar.xsl"/>

<xsl:import href="controls/javascript.xsl"/>


<!-- development mode -->
<xsl:param name="PAPAYA_DBG_DEVMODE" select="false()" />

<!-- page parameters / global variables -->
<xsl:param name="PAGE_TITLE" />
<xsl:param name="PAGE_TITLE_ALIGN" select="true()"/>
<xsl:param name="PAGE_ICON" />
<xsl:param name="PAGE_USER" select="''"/>
<xsl:param name="PAGE_PROJECT">Project</xsl:param>
<xsl:param name="PAGE_REVISION" select="''"/>
<xsl:param name="PAPAYA_VERSION" select="''"/>
<xsl:param name="PAPAYA_MESSAGES_INBOX_NEW" select="0"/>
<xsl:param name="PAPAYA_MESSAGES_INBOX_LINK">messages?msg:folder_id=0</xsl:param>

<xsl:param name="PAPAYA_UI_THEME">green</xsl:param>
<xsl:param name="PAPAYA_PATH_IMAGES">styles/pics</xsl:param>
<xsl:param name="COLUMNWIDTH_LEFT">200px</xsl:param>
<xsl:param name="COLUMNWIDTH_CENTER">100%</xsl:param>
<xsl:param name="COLUMNWIDTH_RIGHT">300px</xsl:param>

<xsl:param name="PAPAYA_UI_LANGUAGE">en-US</xsl:param>
<xsl:param name="PAGE_SELF">index.php</xsl:param>

<!-- PAGE_MODE: page, frameset, frame, installer-->
<xsl:param name="PAGE_MODE">page</xsl:param>
<xsl:param name="PAPAYA_USER_AUTHORIZED" select="false()"/>

<!-- <xsl:param name="PAPAYA_USE_JS_WRAPPER" select="true()" /> -->
<xsl:param name="PAPAYA_USE_JS_WRAPPER" select="not($PAPAYA_DBG_DEVMODE)" />
<xsl:param name="PAPAYA_USE_JS_GZIP" select="true()" />

<xsl:param name="PAPAYA_USE_SWFOBJECT" select="true()" />

<xsl:param name="PAPAYA_USE_RICHTEXT" select="true()" />
<xsl:param name="PAPAYA_USE_TINYMCE_GZIP" select="true()" />
<xsl:param name="PAPAYA_RICHTEXT_TEMPLATES_FULL">p,div,h1,h2,h3,h4,h5,h6,blockquote</xsl:param>
<xsl:param name="PAPAYA_RICHTEXT_TEMPLATES_SIMPLE">p,div,h1,h2,h3</xsl:param>
<xsl:param name="PAPAYA_RICHTEXT_CONTENT_CSS"/>
<xsl:param name="PAPAYA_RICHTEXT_LINK_TARGET">_self</xsl:param>
<xsl:param name="PAPAYA_RICHTEXT_BROWSER_SPELLCHECK" select="false()"/>

<xsl:output method="html" encoding="UTF-8" standalone="yes" indent="yes" />

<xsl:template match="/page">
  <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
  <html>
    <head>
      <meta name="robots" content="noindex, nofollow" />
      <title>
        <xsl:value-of select="$PAGE_PROJECT" />
        <xsl:if test="$PAPAYA_USER_AUTHORIZED and $PAGE_REVISION != ''">
          <xsl:value-of select="concat(' (', $PAGE_REVISION, ')')"/>
        </xsl:if>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="$PAGE_TITLE" /> - papaya CMS</title>
      <link rel="stylesheet" type="text/css" href="styles/css?rev={$PAPAYA_VERSION}&amp;theme={$PAPAYA_UI_THEME}"/>
      <link rel="stylesheet" type="text/css" href="./script/jquery/css/papaya/jquery-ui-1.8.21.custom.css"/>
      <link rel="SHORTCUT ICON" href="styles/themes/{$PAPAYA_UI_THEME}.ico" />
      <xsl:call-template name="application-page-scripts" />
    </head>
    <xsl:choose>
      <xsl:when test="$PAGE_MODE = 'frameset'"><xsl:call-template name="application-frameset" /></xsl:when>
      <xsl:when test="$PAGE_MODE = 'frame'"><xsl:call-template name="application-frame" /></xsl:when>
      <xsl:otherwise><xsl:call-template name="application-page" /></xsl:otherwise>
    </xsl:choose>
  </html>
</xsl:template>

<xsl:template name="application-page">
  <body class="page">
    <div class="pageBorder">
      <xsl:call-template name="application-page-navigation"/>
      <xsl:call-template name="application-page-header"/>
      <xsl:call-template name="application-page-menus"/>
      <xsl:call-template name="application-page-main"/>
      <xsl:call-template name="application-page-footer"/>
    </div>
    <xsl:call-template name="artwork-progress-bar"/>
    <xsl:call-template name="jquery-embed" />
    <xsl:call-template name="richtext-embed" />
  </body>
</xsl:template>

<xsl:template name="application-frameset">
  <xsl:call-template name="jquery-embed" />
  <xsl:copy-of select="/page/centercol/*"/>
</xsl:template>

<xsl:template name="application-frame">
  <body class="framePage">
    <xsl:call-template name="application-page-main"/>
    <xsl:call-template name="jquery-embed" />
  </body>
</xsl:template>

<xsl:template name="application-page-navigation">
  <xsl:if test="$PAPAYA_USER_AUTHORIZED and not($PAGE_MODE = 'installer')">
    <div id="pageNavigation">
      <a href="#pageMenuBar">Menu</a><xsl:text> * </xsl:text>
      <xsl:if test="leftcol">
        <a href="#pageNavigationColumn">Navigation</a><xsl:text> * </xsl:text>
      </xsl:if>
      <a href="#pageContentArea">Content</a>
    </div>
  </xsl:if>
</xsl:template>

<xsl:template name="application-page-main">
  <div id="workarea">
    <xsl:choose>
      <xsl:when test="//login">
        <xsl:call-template name="login-dialog" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="leftColumn" select="leftcol/*"/>
        <xsl:variable name="centerColumn" select="centercol/*"/>
        <xsl:variable name="rightColumn" select="rightcol/*"/>
        <table class="columnGrid">
          <tr>
            <xsl:if test="$leftColumn">
              <td class="columnLeft" style="width: {$COLUMNWIDTH_LEFT}" id="pageNavigationColumn">
                <xsl:apply-templates select="leftcol/*"/>
                <xsl:call-template name="float-fix">
                  <xsl:with-param name="width" select="$COLUMNWIDTH_LEFT"/>
                </xsl:call-template>
              </td>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$rightColumn and (($COLUMNWIDTH_RIGHT = '100%') or ($COLUMNWIDTH_RIGHT = $COLUMNWIDTH_CENTER))">
                <xsl:if test="$centerColumn">
                  <td class="columnCenter" style="width: {$COLUMNWIDTH_CENTER}">
                    <xsl:apply-templates select="$centerColumn[name() != 'toolbar']"/>
                    <xsl:call-template name="float-fix">
                      <xsl:with-param name="width" select="$COLUMNWIDTH_CENTER"/>
                    </xsl:call-template>
                  </td>
                </xsl:if>
                <td class="columnRight" style="width: {$COLUMNWIDTH_RIGHT}" id="pageContentArea">
                  <xsl:if test="count(toolbars/*|$rightColumn[name() = 'toolbar']) &gt; 0">
                    <h2 class="nonGraphicBrowser">
                      <xsl:call-template name="translate-phrase">
                        <xsl:with-param name="phrase">Content Toolbar</xsl:with-param>
                      </xsl:call-template>
                    </h2>
                    <xsl:apply-templates select="toolbars/*"/>
                    <xsl:apply-templates select="$rightColumn[name() = 'toolbar']"/>
                  </xsl:if>
                  <xsl:call-template name="application-messages"/>
                  <xsl:apply-templates select="$rightColumn[name() != 'toolbar']"/>
                </td>
              </xsl:when>
              <xsl:when test="$rightColumn and (toolbars/* or $centerColumn[name() = 'toolbar'] or messages/*)">
                <td>
                  <table class="columnGrid" cellspacing="0">
                    <tr>
                      <td class="columnToolbar" colspan="2" id="pageContentArea">
                        <xsl:if test="count(toolbars/*|$centerColumn[name() = 'toolbar']) &gt; 0">
                          <h2 class="nonGraphicBrowser">
                            <xsl:call-template name="translate-phrase">
                              <xsl:with-param name="phrase">Content Toolbar</xsl:with-param>
                            </xsl:call-template>
                          </h2>
                          <xsl:apply-templates select="toolbars/*"/>
                          <xsl:apply-templates select="$centerColumn[name() = 'toolbar']"/>
                        </xsl:if>
                        <xsl:call-template name="application-messages"/>
                      </td>
                    </tr>
                    <tr>
                      <td class="columnCenter" style="width: {$COLUMNWIDTH_CENTER}">
                         <xsl:apply-templates select="$centerColumn[name() != 'toolbar']"/>
                         <xsl:call-template name="float-fix">
                           <xsl:with-param name="width" select="$COLUMNWIDTH_CENTER"/>
                         </xsl:call-template>
                      </td>
                      <td class="columnRight" style="width: {$COLUMNWIDTH_RIGHT}">
                        <xsl:apply-templates select="$rightColumn[name() != 'toolbar']"/>
                        <xsl:call-template name="float-fix">
                          <xsl:with-param name="width" select="$COLUMNWIDTH_RIGHT"/>
                        </xsl:call-template>
                      </td>
                    </tr>
                  </table>
                </td>
              </xsl:when>
              <xsl:otherwise>
                <td class="columnCenter" style="width: {$COLUMNWIDTH_CENTER}" id="pageContentArea">
                  <xsl:if test="count(toolbars/*|$centerColumn[name() = 'toolbar']) &gt; 0">
                    <h2 class="nonGraphicBrowser">
                      <xsl:call-template name="translate-phrase">
                        <xsl:with-param name="phrase">Content Toolbar</xsl:with-param>
                      </xsl:call-template>
                    </h2>
                    <xsl:apply-templates select="toolbars/*"/>
                    <xsl:apply-templates select="$centerColumn[name() = 'toolbar']"/>
                  </xsl:if>
                  <xsl:call-template name="application-messages"/>
                  <xsl:apply-templates select="$centerColumn[name() != 'toolbar']"/>
                  <xsl:call-template name="float-fix">
                    <xsl:with-param name="width" select="$COLUMNWIDTH_CENTER"/>
                  </xsl:call-template>
                </td>
                <xsl:if test="$rightColumn">
                  <td class="columnRight" style="width: {$COLUMNWIDTH_RIGHT}">
                    <xsl:apply-templates select="$rightColumn[name() != 'toolbar']"/>
                    <xsl:call-template name="float-fix">
                      <xsl:with-param name="width" select="$COLUMNWIDTH_RIGHT"/>
                    </xsl:call-template>
                    <xsl:text> </xsl:text>
                  </td>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<xsl:template name="application-page-header">
  <div id="title">
    <xsl:call-template name="title-artwork"/>
    <xsl:call-template name="application-page-buttons"/>
    <xsl:variable name="glyphsrc">
      <xsl:call-template name="icon-url">
        <xsl:with-param name="icon-src" select="$PAGE_ICON"/>
        <xsl:with-param name="icon-size">22</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <div class="papayaLogo">
      <xsl:copy-of select="document('svg/papaya-logo.svg')/*"/>
    </div>
    <xsl:if test="$PAGE_ICON and ($PAGE_ICON != '')">
      <img src="{$glyphsrc}" class="pageLogo" alt="" />
    </xsl:if>
    <h1 id="titleText"><xsl:value-of select="$PAGE_TITLE" /></h1>
  </div>
  <div id="titleMenu">
    <xsl:if test="$PAPAYA_USER_AUTHORIZED and not($PAGE_MODE = 'installer')">
      <xsl:call-template name="application-page-links-right"/>
    </xsl:if>
    <a href="../" target="_blank">
      <xsl:attribute name="title">
        <xsl:call-template name="translate-phrase">
          <xsl:with-param name="phrase">Website</xsl:with-param>
        </xsl:call-template>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="$PAGE_PROJECT" />
        <xsl:if test="$PAPAYA_USER_AUTHORIZED and $PAGE_REVISION != ''">
          <xsl:value-of select="concat(' (', $PAGE_REVISION, ')')"/>
        </xsl:if>
      </xsl:attribute>
      <xsl:value-of select="$PAGE_PROJECT" />
      <xsl:if test="$PAPAYA_USER_AUTHORIZED and $PAGE_REVISION != ''">
        <xsl:value-of select="concat(' (', $PAGE_REVISION, ')')"/>
      </xsl:if>
    </a>
    <xsl:if test="$PAGE_USER != ''">
      <xsl:text> - </xsl:text>
      <span class="user">
        <xsl:value-of select="$PAGE_USER" />
        <xsl:if test="$PAPAYA_MESSAGES_INBOX_NEW &gt; 0">
          (<a href="{$PAPAYA_MESSAGES_INBOX_LINK}"><xsl:value-of select="$PAPAYA_MESSAGES_INBOX_NEW" /></a>)
        </xsl:if>
      </span>
    </xsl:if>
    <xsl:if test="$PAPAYA_USER_AUTHORIZED and not($PAGE_MODE = 'installer')">
       <xsl:call-template name="application-page-links"/>
    </xsl:if>
  </div>
</xsl:template>

<xsl:template name="application-page-footer">
  <div id="footer">
    <xsl:call-template name="artwork-overlay"/>
    <span class="versionString">
      <a href="http://www.papaya-cms.com/" target="_blank">
        <xsl:text>papaya CMS </xsl:text>
        <xsl:if test="$PAPAYA_USER_AUTHORIZED and $PAPAYA_VERSION != ''">
          (<xsl:value-of select="$PAPAYA_VERSION"/>)
        </xsl:if>
      </a>
    </span>
  </div>
</xsl:template>

<xsl:template name="application-page-buttons">
  <xsl:if test="$PAPAYA_USER_AUTHORIZED and not($PAGE_MODE = 'installer')">
    <xsl:variable name="captionLogOut">
      <xsl:call-template name="translate-phrase">
        <xsl:with-param name="phrase">Logout</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="captionHelp">
      <xsl:call-template name="translate-phrase">
        <xsl:with-param name="phrase">Help</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <div id="titleButtons">
      <a href="help" id="papayaTitleButtonHelp" title ="{$captionHelp}"><img src="icon.categories.help?size=22" alt="{$captionHelp}" title ="{$captionHelp}" class="glyph22"/></a>
      <a href="logout" id="papayaTitleButtonLogout" title ="{$captionLogOut}"><img src="icon.actions.log-out?size=22" alt="{$captionLogOut}" title ="{$captionLogOut}" class="glyph22"/></a>
    </div>
  </xsl:if>
</xsl:template>

<xsl:template name="application-page-menus">
  <xsl:if test="menus/menu and $PAPAYA_USER_AUTHORIZED and not($PAGE_MODE = 'installer')">
    <div id="pageMenuBar">
      <xsl:for-each select="menus/menu[@ident = 'main']">
        <xsl:call-template name="menu-bar">
          <xsl:with-param name="menu" select="."/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:if test="count(menus/menu[not(@ident) or @ident != 'main']) &gt; 0">
        <h2 class="nonGraphicBrowser">
          <xsl:call-template name="translate-phrase">
            <xsl:with-param name="phrase">Actions</xsl:with-param>
          </xsl:call-template>
        </h2>
        <xsl:for-each select="menus/menu[not(@ident) or @ident != 'main']">
          <xsl:call-template name="menu-bar">
            <xsl:with-param name="menu" select="."/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:if>
    </div>
  </xsl:if>
</xsl:template>

<xsl:template name="application-page-links-right">
  <xsl:if test="title-menu/links[@align = 'right']/@title">
    <script type="text/javascript"><xsl:comment>
      <xsl:for-each select="title-menu/links[@align = 'right']/link">
        <xsl:variable name="selected">
          <xsl:choose>
            <xsl:when test="@selected">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        PapayaRichtextSwitch.add("<xsl:value-of select="@title"/>", "<xsl:value-of select="@href"/>", <xsl:value-of select="$selected"/>);
      </xsl:for-each>
      PapayaRichtextSwitch.output(document.getElementById("titleMenu"), "<xsl:value-of select="title-menu/links[@align = 'right']/@title"/>");
    //</xsl:comment></script>
  </xsl:if>
</xsl:template>

<xsl:template name="application-page-links">
  <xsl:if test="title-menu/links[not(@align)]/@title">
    - <ul class="links">
      <li class="caption"><xsl:value-of select="title-menu/links[not(@align)]/@title"/>: </li>
      <xsl:if test="title-menu/links[not(@align)]/link[@selected]">
        <xsl:variable name="selectedLink" select="title-menu/links[not(@align)]/link[@selected]"/>
        <li class="selected">
          <xsl:choose>
            <xsl:when test="contains($selectedLink/@image, '.gif')">
              <img src="pics/language/{substring-before($selectedLink/@image, '.gif')}.svg" alt="" title="{$selectedLink/@title}" style="height:1.2em; margin-right: 4px;"/>
            </xsl:when>
            <xsl:when test="contains($selectedLink/@image, '.svg')">
              <img src="pics/language/{$selectedLink/@image}" alt="" title="{$selectedLink/@title}" style="height:1.2em; margin-right: 4px;"/>
            </xsl:when>
          </xsl:choose>
          <xsl:value-of select="$selectedLink/@title"/>
        </li>
      </xsl:if>
      <xsl:if test="count(title-menu/links[not(@align)]/link) &gt; 0">
        <xsl:for-each select="title-menu/links[not(@align)]/link[not(@selected)]">
          <li>
            <a href="{@href}" title="{@title}">
              <xsl:choose>
                <xsl:when test="contains(@image, '.gif')">
                  <img src="pics/language/{substring-before(@image, '.gif')}.svg" alt="" title="{@title}" style="height:1.2em;"/>
                </xsl:when>
                <xsl:when test="contains(@image, '.svg')">
                  <img src="pics/language/{@image}" alt="" title="{@title}" style="height:1.2em;"/>
                </xsl:when>
                <xsl:otherwise><xsl:value-of select="@title"/></xsl:otherwise>
              </xsl:choose>
            </a>
          </li>
        </xsl:for-each>
      </xsl:if>
    </ul>
  </xsl:if>
</xsl:template>

<xsl:template name="application-messages">
  <xsl:call-template name="messages">
    <xsl:with-param name="messages" select="messages/msg|messages/message"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="application-page-scripts">
  <script type="text/javascript" src="./script/jquery/js/jquery-1.7.2.min.js"><xsl:text> </xsl:text></script>
  <script type="text/javascript" src="./styles/js?rev={$PAPAYA_VERSION}"><xsl:text> </xsl:text></script>
  <xsl:if test="$PAPAYA_USER_AUTHORIZED">

    <xsl:choose>
      <xsl:when test="$PAPAYA_USE_JS_WRAPPER">
        <xsl:variable name="jsQueryString">
          <xsl:text>files=jsonclass.js,xmlrpc.js</xsl:text>
          <xsl:if test="$PAPAYA_USE_SWFOBJECT">,swfobject/swfobject.js</xsl:if>
        </xsl:variable>
        <script type="text/javascript" src="scripts?{$jsQueryString}&amp;rev={$PAPAYA_VERSION}"> </script>
      </xsl:when>
      <xsl:otherwise>
        <script type="text/javascript" src="./script/jsonclass.js?rev={$PAPAYA_VERSION}"> </script>
        <script type="text/javascript" src="./script/xmlrpc.js?rev={$PAPAYA_VERSION}"> </script>
        <xsl:if test="$PAPAYA_USE_SWFOBJECT">
          <script type="text/javascript" src="./script/swfobject/swfobject.js?rev={$PAPAYA_VERSION}"> </script>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
  <xsl:for-each select="scripts/script">
    <script type="{@type}">
      <xsl:if test="@src">
        <xsl:attribute name="src"><xsl:value-of select="@src"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="@language">
        <xsl:attribute name="language"><xsl:value-of select="@language"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="text() != ''">
        <xsl:comment>
          <xsl:value-of select="." disable-output-escaping="yes"/>
        //</xsl:comment>
      </xsl:if>
      <xsl:text> </xsl:text>
    </script>
  </xsl:for-each>
</xsl:template>

<xsl:template name="jquery-embed">
  <xsl:if test="$EMBED_JQUERY">
    <xsl:variable name="scripts">
      <script>jquery/js/jquery-ui-1.8.21.custom.min.js</script>
      <script>jquery/js/timepicker.js</script>
      <script>jquery.papayaUtilities.js</script>
      <script>jquery.papayaPopIn.js</script>
      <script>jquery.papayaPopUp.js</script>
      <script>jquery.papayaDialogManager.js</script>
      <script>jquery.papayaDialogHints.js</script>
      <script>jquery.papayaDialogField.js</script>
      <script>jquery.papayaDialogFieldColor.js</script>
      <script>jquery.papayaDialogFieldCounted.js</script>
      <script>jquery.papayaDialogFieldDateRange.js</script>
      <script>jquery.papayaDialogFieldGeoPosition.js</script>
      <script>jquery.papayaDialogFieldImage.js</script>
      <script>jquery.papayaDialogFieldImageResized.js</script>
      <script>jquery.papayaDialogFieldMediaFile.js</script>
      <script>jquery.papayaDialogFieldPage.js</script>
      <script>jquery.papayaDialogFieldSelect.js</script>
      <script>jquery.papayaDialogCheckboxes.js</script>
      <script>jquery.papayaDialogFieldSuggest.js</script>
      <script>controls.js</script>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$PAPAYA_USE_JS_WRAPPER">
        <xsl:variable name="jsQueryString">
          <xsl:text>files=</xsl:text>
          <xsl:for-each select="exslt:node-set($scripts)/script">
            <xsl:if test="position() > 1">
              <xsl:text>,</xsl:text>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:for-each>
        </xsl:variable>
        <script type="text/javascript" src="scripts?{$jsQueryString}&amp;rev={$PAPAYA_VERSION}"> </script>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="exslt:node-set($scripts)/script">
          <script type="text/javascript" src="script/{.}?rev={$PAPAYA_VERSION}"> </script>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="changedMessage">
      <xsl:call-template name="translate-phrase">
        <xsl:with-param name="phrase">Content changed</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <script type="text/javascript">
      <xsl:comment>
        if ($.papayaDialogManager) {
          $.papayaDialogManager().settings.message = '<xsl:value-of select="$changedMessage"/>';
        }
      //</xsl:comment>
    </script>
  </xsl:if>
</xsl:template>

<xsl:template name="richtext-embed">
  <xsl:if test="$PAPAYA_USE_RICHTEXT and $EMBED_TINYMCE">
    <xsl:variable name="tinymce">tiny_mce3</xsl:variable>
    <xsl:variable name="language-short">
      <xsl:choose>
        <xsl:when test="substring-before($PAPAYA_UI_LANGUAGE, '-')"><xsl:value-of select="substring-before($PAPAYA_UI_LANGUAGE, '-')"/></xsl:when>
        <xsl:otherwise>en</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$PAPAYA_USE_TINYMCE_GZIP">
        <script type="text/javascript" src="./script/{$tinymce}/tiny_mce_gzip.js?rev={$PAPAYA_VERSION}"></script>
        <script type="text/javascript" src="./script/{$tinymce}.js?rev={$PAPAYA_VERSION}"></script>
        <script type="text/javascript"><xsl:comment>
          <xsl:if test="$PAPAYA_DBG_DEVMODE">
            tinyMCELoading.disk_cache = false;
            tinyMCELoading.suffix = '_src';
          </xsl:if>
          <xsl:if test="$language-short != 'en'">
            tinyMCELoading.languages = '<xsl:value-of select="$language-short"/>';
          </xsl:if>
          tinyMCELoading.revision = '<xsl:value-of select="$PAPAYA_VERSION"/>';
          tinyMCE_GZ.init(tinyMCELoading);
        //</xsl:comment></script>
      </xsl:when>
      <xsl:when test="$PAPAYA_DBG_DEVMODE">
        <script type="text/javascript" src="./script/{$tinymce}/tiny_mce_src.js?rev={$PAPAYA_VERSION}"></script>
        <script type="text/javascript" src="./script/{$tinymce}.js?rev={$PAPAYA_VERSION}"></script>
      </xsl:when>
      <xsl:otherwise>
        <script type="text/javascript" src="./script/{$tinymce}/tiny_mce.js?rev={$PAPAYA_VERSION}"></script>
        <script type="text/javascript" src="./script/{$tinymce}.js?rev={$PAPAYA_VERSION}"></script>
      </xsl:otherwise>
    </xsl:choose>
    <script type="text/javascript"><xsl:comment>
      tinyMCEOptionsSimple.content_css = '<xsl:call-template name="richtext-embed-content-css"/>';
      tinyMCEOptionsFull.content_css = '<xsl:call-template name="richtext-embed-content-css"/>';
      <xsl:if test="$PAPAYA_RICHTEXT_CONTENT_CSS">
        tinyMCEOptionsSimple.theme_advanced_buttons1_add = 'styleselect';
        tinyMCEOptionsFull.theme_advanced_buttons1_add = 'styleselect';
      </xsl:if>
      tinyMCEOptionsSimple.theme_advanced_blockformats = '<xsl:value-of select="$PAPAYA_RICHTEXT_TEMPLATES_SIMPLE"/>';
      tinyMCEOptionsFull.theme_advanced_blockformats = '<xsl:value-of select="$PAPAYA_RICHTEXT_TEMPLATES_FULL"/>';
      <xsl:if test="$language-short != 'en'">
        tinyMCEOptionsSimple.language = '<xsl:value-of select="$language-short"/>';
        tinyMCEOptionsFull.language = '<xsl:value-of select="$language-short"/>';
      </xsl:if>
      <xsl:if test="$PAPAYA_RICHTEXT_BROWSER_SPELLCHECK">
        tinyMCEOptionsSimple.gecko_spellcheck = true;
        tinyMCEOptionsFull.gecko_spellcheck = true;
      </xsl:if>
      tinyMCEOptionsSimple.papayaParser.linkTarget = '<xsl:value-of select="$PAPAYA_RICHTEXT_LINK_TARGET"/>';
      tinyMCEOptionsFull.papayaParser.linkTarget = '<xsl:value-of select="$PAPAYA_RICHTEXT_LINK_TARGET"/>';
      tinyMCE.init(tinyMCEOptionsSimple);
      tinyMCE.init(tinyMCEOptionsFull);
    //</xsl:comment></script>
  </xsl:if>
</xsl:template>

<xsl:template name="richtext-embed-content-css">
  <xsl:text>styles/css.richtext?rev=</xsl:text>
  <xsl:value-of select="$PAPAYA_VERSION"/>
  <xsl:text>&amp;theme=</xsl:text>
  <xsl:value-of select="$PAPAYA_UI_THEME"/>
  <xsl:if test="$PAPAYA_RICHTEXT_CONTENT_CSS">
    <xsl:text>,</xsl:text>
    <xsl:value-of select="$PAPAYA_RICHTEXT_CONTENT_CSS"/>
  </xsl:if>
</xsl:template>

  <xsl:template name="title-artwork">
    <div class="artwork artworkLeft">
      <xsl:copy-of select="document('svg/leaf-left.svg')/*"/>
    </div>
    <div class="artwork artworkRight">
      <xsl:copy-of select="document('svg/leaf-right.svg')/*"/>
    </div>
    <xsl:call-template name="artwork-overlay"/>
  </xsl:template>

  <xsl:template name="artwork-overlay">
    <div class="artwork artworkOverlay">
      <xsl:copy-of select="document('svg/dots.svg')/*"/>
    </div>
  </xsl:template>

  <xsl:template name="artwork-progress-bar">
    <div id="progressBarArtwork" style="width: 1px; height: 1px; position: absolute; left: -100px;">
      <xsl:copy-of select="document('svg/progress-bar.svg')/*"/>
    </div>
  </xsl:template>

</xsl:stylesheet>
