/*
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

function addUploadButton(title, paramName) {
  if (typeof paramName === 'undefined') {
    paramName = 'mdb';
  }
  var i = 0;
  do {
    i++;
  } while (document.getElementById(paramName+'_upload_' + i));

  var addButtonLine = document.getElementById(paramName+'_upload_' + (i - 1)).parentNode.parentNode;

  var newLine = document.createElement('tr');

  if (addButtonLine.className === 'even') {
    newLine.className = 'odd';
  } else {
    newLine.className = 'even';
  }


  var firstColumn = document.createElement('td');
  firstColumn.appendChild(document.createTextNode(title + ' ' + (i+1)));
  firstColumn.className = 'caption';
  newLine.appendChild(firstColumn);

  var secondColumn = document.createElement('td');
  secondColumn.className = 'infos';
  newLine.appendChild(secondColumn);

  var tableField = document.createElement('input');
  tableField.setAttribute('type', 'file');
  tableField.setAttribute('size', '18');
  tableField.setAttribute('class', 'file');
  tableField.setAttribute('id', paramName + '_upload_' + i);
  tableField.setAttribute('name', paramName + '[upload][' + i + ']');

  var thirdColumn = document.createElement('td');
  thirdColumn.appendChild(tableField);
  thirdColumn.className = 'element';
  newLine.appendChild(thirdColumn);

  addButtonLine.parentNode.appendChild(newLine);
}

function invertCheckBoxes(element) {
  var form = element.parentNode.parentNode.parentNode;
  var inputs = form.getElementsByTagName('input');
  if (inputs.length > 0) {
    for (var i = 0; i < inputs.length; i++) {
      if (inputs[i].getAttribute('type') === 'checkbox') {
        inputs[i].checked = !(inputs[i].checked);
      }
    }
  }
}
