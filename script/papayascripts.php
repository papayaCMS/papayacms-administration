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

if (!empty($_GET['gzip']) && $_GET['gzip'] == 'true') {
  $allowCompress = TRUE;
} else {
  $allowCompress = FALSE;
}
if (!empty($_GET['swfobject']) && $_GET['swfobject'] == 'true') {
  $includeSWFObject = TRUE;
} else {
  $includeSWFObject = FALSE;
}

/**
* Administration page functions
*/
require_once(dirname(dirname(__FILE__)).'/inc.func.php');
controlScriptFileCaching(__FILE__, FALSE, $allowCompress, 3);
header('Content-type: text/javascript');

echo "/* jsonclass.js */\n\n";
readfile('jsonclass.js');

echo "/* xmlrpc.js */\n\n";
readfile('xmlrpc.js');

echo "\n\n/* controls.js */\n\n";
readfile('controls.js');

if ($includeSWFObject) {
  echo "\n\n/* swfobject/swfobject.js */\n\n";
  readfile('swfobject/swfobject.js');
} else {
  echo "\n\n/* swfobject dummy */\n\n";
  echo "\nvar swfobject = { registerObject : function() { } };\n";
}
