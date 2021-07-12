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

if ($application = include __DIR__.'/bootstrap.php') {
  $administrationUI = new \Papaya\CMS\Administration\UI(__DIR__, $application);
  if (($response = $administrationUI->execute()) instanceof \Papaya\Response) {
    $response->send(TRUE);
  }
} else {
  //no installer found - output error message and exit
  // @codingStandardsIgnoreStart
  ?>
  <html>
    <head>
      <title>papaya CMS</title>
      <style type="text/css">
        body {
          font-family: Verdana, Arial, Helvetic, sans serif;
          font-size: 14px;
          background-color: threedface;
        }
        h1 {
          width: 400px;
          margin: 40px auto;
          padding: 4px;
          text-align: center;
        }
        div.error {
          width: 400px;
          background-color: window;
          color: windowtext;
          border: 1px inset threedface;
          margin: 20px auto;
          padding: 4px;
        }
        .optname {
          font-family: monospace;
          font-weight: bold;
        }
        .filename {
          font-family: monospace;
        }
        div.options {
          width: 600px;
          background-color: window;
          color: windowtext;
          border: 1px inset threedface;
          margin: 20px auto;
          padding: 0px;
        }
        div.options table {
          width: 100%;
          background-color: window;
          color: windowtext;
          border-collapse: collapse;
        }
        div.options table th {
          border: 1px solid threedshadow;
          font-size: 13px;
        }
        div.options table td {
          border: 1px solid threedshadow;
          font-weight: bold;
          font-family: monospace;
          font-size: 12px;
        }
        div.options table td + td {
          font-weight: normal;
          font-size: 12px;
        }
      </style>
    </head>
    <body>
      <h1>Error</h1>
      <div class="error">
        The system can not find the class framework. Please check the
        <span class="optname">PAPAYA_INCLUDE_PATH</span> in the
        <span class="filename">papaya.php</span> in your install path. The
        <span class="optname">PAPAYA_INCLUDE_PATH</span> can be an absolute path or a
        subdirectory of your <span class="optname">include_path</span> in the php
        configuration.
      </div>
      <div class="options">
        <table summary="Current option values">
          <thead>
            <tr>
              <th>Name</th>
              <th>Value</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>DOCUMENT_ROOT</td>
              <td><?php echo $_SERVER['DOCUMENT_ROOT'] ?></td>
            </tr>
            <tr>
              <td>include_path</td>
              <td><?php echo get_include_path(); ?></td>
            </tr>
            <tr>
              <td>PAPAYA_INCLUDE_PATH</td>
              <td>
                <?php echo defined('PAPAYA_INCLUDE_PATH') ? PAPAYA_INCLUDE_PATH : ''; ?>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </body>
  </html>

  <?php
  // @codingStandardsIgnoreEnd
}
