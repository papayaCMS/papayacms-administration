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

var PapayaRichtextSwitch = {

  items : [],

  add : function (caption, href, selected) {
    this.items[this.items.length] = {
      caption : caption,
      href : href,
      selected : selected
    };
  },

  output : function (parentNode, caption) {
    if (parentNode) {
      var list = document.createElement('ul');
      list.className = 'rightLinks';
      var captionElement = document.createElement('li');
      captionElement.className = 'caption';
      var captionText = document.createTextNode(caption);
      captionElement.appendChild(captionText);
      list.appendChild(captionElement);
      for (var i = 0; i < this.items.length; i++) {
        var itemElement = document.createElement('li');
        if (this.items[i].selected) {
          itemElement.className = 'selected';
        }
        var itemLink = document.createElement('a');
        itemLink.setAttribute('href', this.items[i].href);
        var itemText = document.createTextNode(this.items[i].caption);
        itemLink.appendChild(itemText);
        itemElement.appendChild(itemLink);
        list.appendChild(itemElement);
      }
      parentNode.insertBefore(list, parentNode.firstChild);
    }
  }
};
