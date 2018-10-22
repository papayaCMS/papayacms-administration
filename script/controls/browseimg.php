<?php
/**
 * papaya CMS
 *
 * @copyright 2000-2018 by papayaCMS project - All rights reserved.
 * @link http://www.papaya-cms.com/
 * @license http://www.gnu.org/licenses/old-licenses/gpl-2.0.html GNU General Public License, version 2
 *
 *  You can redistribute and/or modify this script under the terms of the GNU General Public
 *  License (GPL) version 2, provided that the copyright and license notes, including these
 *  lines, remain unmodified. papaya is distributed in the hope that it will be useful, but
 *  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 *  FOR A PARTICULAR PURPOSE.
 */

/**
* incusion of base or additional libraries
*/
require_once(dirname(__FILE__).'/inc.controls.php');
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <title><?php echo _gt('Image browser');?></title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8">
    <link rel="stylesheet"
          type="text/css" href="../../skins/<?php echo $PAPAYA_SKIN; ?>/css.popups.php">
    <script type="text/javascript" src="../imgbrowser.js"></script>
    <script type="text/javascript">
var linkList = "../../content.file.browser?mdb[mode]=list";
var linkPreview = "../../content.file.browser?mdb[mode]=preview&mdb[imagesonly]=1";
var linkThumbs = "../../content.file.browser?mdb[mode]=thumbs&mdb[dialog]=no&mdb[imagesonly]=1";

var mediaFileData = {};
var papayaContext = null;

function Cancel() {
  if (papayaContext) {
    papayaContext.defer.reject();
  }
  if (!window.frameElement) {
    window.close();
  }
}

function Ok() {
  if (papayaContext) {
    papayaContext.defer.resolve(mediaFileData);
  } else if ((typeof linkedObject != 'undefined') && linkedObject != null) {
    if (linkedObject.setMediaFileData) {
      linkedObject.setMediaFileData(mediaFileData.id, mediaFileData);
    }
  } else if (window.opener.setMediaFileData) {
    window.opener.setMediaFileData(mediaFileData.id, mediaFileData);
  }
  if (!window.frameElement) {
    window.close();
  }
}

function setMediaFileData(fileId, fileData) {
  mediaFileData = fileData;
  mediaFileData.orgWidth = fileData.width;
  mediaFileData.orgHeight = fileData.height;
}
    </script>
  </head>
  <frameset rows="40,*,50" style="border: none;" frameborder="no" border="0" framespacing="0">
    <frame src="browseheader.php" style="border: none;"/>
    <frameset cols="300,*" style="border-width: 3px;" frameborder="yes" border="3"
      framespacing="3" bordercolor="#FFFFFF">
      <frameset rows="*,200">
        <frame src="../../content.file.browser?mdb[mode]=list" id="frmFolders"/>
        <frame id="frmPreview" scrolling="no"
          src="../../content.file.browser?mdb[mode]=preview&amp;mdb[imagesonly]=1"/>
      </frameset>
      <frame id="frmThumbs"
        src="../../content.file.browser?mdb[mode]=thumbs&amp;mdb[dialog]=no&amp;mdb[imagesonly]=1"/>
    </frameset>
    <frame src="browsebtns.php" style="border: none;"/>
  </frameset>
</html>
