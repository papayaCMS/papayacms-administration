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
* Configuration file
*/
require_once __DIR__.'/inc.conf.php';
require_once __DIR__.'/inc.func.php';

define('PAPAYA_ADMIN_PAGE', TRUE);
/**
 * check include path - try to include installer, and application object
 *
 * @var Papaya\Application\Cms $application Application object
 */
if (defined('PAPAYA_DBG_DEVMODE') && PAPAYA_DBG_DEVMODE) {
  $application = include_once(__DIR__.'/inc.application.php');
} else {
  $application = @include_once(__DIR__.'/inc.application.php');
}

if (!$application) {
  //no installer found - output error message and exit
  // @codingStandardsIgnoreStart
  ?>
  <html>
    <head>
      <title>Papaya-CMS Installer</title>
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
} else {
  /**
  * button glyphs
  */
  include_once('./inc.glyphs.php');

  // check if the options table is present
  $installer = new \papaya_installer();
  $status = $installer->getCurrentStatus();

  $options = $application->options;
  $options->defineConstants();

  if ($options->get('PAPAYA_UI_SECURE', FALSE) &&
      !\Papaya\Utility\Server\Protocol::isSecure()) {
    $url = 'https://'.$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI'];
    redirectToURL($url);
  }

  $application->messages->setUp($options);

  header('Content-type: text/html; charset=utf-8');

  /**
  * layout object
  */
  $PAPAYA_LAYOUT = new \PapayaTemplateXslt(
    dirname(__FILE__)."/skins/".$options->get('PAPAYA_UI_SKIN', 'default')."/style.xsl"
  );

  $PAPAYA_LAYOUT->parameters()->assign(
    array(
      'PAGE_TITLE' => _gt('Administration').' - '._gt('Installation / Update'),
      'PAGE_ICON' => $application->images['categories-installer'],
      'PAGE_PROJECT' => '',
      'PAGE_USER' => 'NO USER'
    )
  );

  //create session
  define('PAPAYA_ADMIN_SESSION', TRUE);
  $application->session->setName(
    'sid'.$options->get('PAPAYA_SESSION_NAME', '').'admin'
  );

  $application->session->options->cache = \Papaya\Session\Options::CACHE_NONE;
  if ($redirect = $application->session->activate(TRUE)) {
    $redirect->send();
    exit();
  }

  if (
    !(
      \Papaya\Utility\Server\Protocol::isSecure() ||
      preg_match('(^localhost(:\d+)?$)i', \Papaya\Utility\Server\Name::get())
    )
  ) {
    $dialog = new \PapayaUiDialog();
    $dialog->caption = new \PapayaUiStringTranslated('Warning');
    $url = new \Papaya\Url\Current();
    $url->setScheme('https');
    $dialog->action($url->getUrl());
    $dialog->fields[] = new \PapayaUiDialogFieldMessage(
      \Papaya\Message::SEVERITY_WARNING,
      new \PapayaUiStringTranslated(
        'If possible, please use https to access the administration interface.'
      )
    );
    $dialog->buttons[] = new \PapayaUiDialogButtonSubmit(
      new \PapayaUiStringTranslated('Use https')
    );
    $PAPAYA_LAYOUT->add($dialog->getXml());
  }

  $installer->layout = $PAPAYA_LAYOUT;
  $installer->initialize();
  $installer->execute();

  if (!$installer->rpcResponseSent) {
    print $PAPAYA_LAYOUT->getOutput();
  }
}
