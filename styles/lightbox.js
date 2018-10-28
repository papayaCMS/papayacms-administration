
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
var PapayaLightBox = {

  elements : {
    box : null,
    dialog : null,
    dialogTitle : null,
    dialogMessage : null,
    bar : null,
    button : null,
    buttonTitle : null
  },

  init : function(titleStr, buttonStr) {
    var artworks, i;
    if (!this.elements.box) {
      //create the box
      this.elements.box = document.createElement('div');
      this.elements.box.id = 'lightBox';
      document.body.appendChild(this.elements.box);
      //create the dialog
      this.elements.dialog = document.createElement('div');
      this.elements.dialog.id = 'lightBoxDialog';
      document.body.appendChild(this.elements.dialog);
      //dialog title bar
      var titleBar = document.createElement('div');
      titleBar.className = 'title';
      this.elements.dialog.appendChild(titleBar);

      artworks = document.querySelectorAll('#title .artworkOverlay');
      for (i = 0; i < artworks.length; i++) {
        titleBar.appendChild(artworks[i].cloneNode(true));
      }

      var title = document.createElement('h1');
      title.className = 'lightBoxDialogTitle';
      titleBar.appendChild(title);

      this.elements.dialogTitle = document.createTextNode('dialog title');
      title.appendChild(this.elements.dialogTitle);

      var progressDialog = document.createElement('div');
      progressDialog.className = 'progressDialog';
      this.elements.dialog.appendChild(progressDialog);

      var message = document.createElement('h2');
      message.className = 'progressDialogMessage';
      progressDialog.appendChild(message);

      this.elements.dialogMessage = document.createTextNode('dialog message');
      message.appendChild(this.elements.dialogMessage);

      var progressBarBorder = document.createElement('div');
      progressBarBorder.className = 'progressBarBorder';
      progressDialog.appendChild(progressBarBorder);

      this.elements.bar = document.createElement('div');
      this.elements.bar.className = 'progressBar';
      progressBarBorder.appendChild(this.elements.bar);

      artworks = document.querySelectorAll('#progressBarArtwork > *');
      for (i = 0; i < artworks.length; i++) {
        this.elements.bar.appendChild(artworks[i].cloneNode(true));
      }

      var buttonArea = document.createElement('div');
      buttonArea.className = 'lightBoxButtons';
      progressDialog.appendChild(buttonArea);

      this.elements.button = document.createElement('button');
      this.elements.button.className = 'progressBarButton';
      this.elements.button.onclick = function () {
        PapayaLightBox.hide();
      };
      buttonArea.appendChild(this.elements.button);

      this.elements.buttonTitle = document.createTextNode('dialog button');
      this.elements.button.appendChild(this.elements.buttonTitle);

      var footer = document.createElement('div');
      footer.className = 'footer';
      progressDialog.appendChild(footer);

      artworks = document.querySelectorAll('#footer .artworkOverlay');
      for (i = 0; i < artworks.length; i++) {
        footer.appendChild(artworks[i].cloneNode(true));
      }
    }
    if (titleStr) {
      this.elements.dialogTitle.nodeValue = titleStr;
    }
    if (buttonStr) {
      this.elements.buttonTitle.nodeValue = buttonStr;
    }
  },

  show : function() {
    this.init();
    if (this && this.elements) {
      if (this.elements.dialog.style.display !== 'block') {
        //resize lightbox to document size
        var scrollWidth = document.body.scrollWidth;
        if (document.body.offsetWidth > scrollWidth) {
          scrollWidth = document.body.offsetWidth;
        }
        var scrollHeight = document.body.scrollHeight;
        if (document.body.offsetHeight > scrollHeight) {
          scrollHeight = document.body.offsetHeight;
        }
        this.elements.box.style.height = scrollHeight;
        this.elements.box.style.width = scrollWidth;

        //move lightbox dialog
        var windowWidth;
        if (self.innerWidth) {
          // all except Explorer
        	windowWidth = self.innerWidth;
        } else if (document.documentElement && document.documentElement.clientWidth) {
        	// Explorer 6 Strict Mode
        	windowWidth = document.documentElement.clientWidth;
        } else if (document.body) {
          // other Explorers
        	windowWidth = document.body.clientWidth;
        }
        var newLeft = parseInt((windowWidth - 400) / 2, 10);
        if (this.elements.dialog.style.pixelLeft) {
          this.elements.dialog.style.pixelLeft = newLeft;
        } else {
          this.elements.dialog.style.left = newLeft + "px";
        }
        this.elements.dialog.style.display = 'block';
      }
      if (this.elements.box.style.display !== 'block') {
        this.elements.box.style.display = 'block';
      }
      document.body.setAttribute('data-listbox-active', 'yes');
    }
  },

  hide : function() {
    document.body.removeAttribute('data-listbox-active');
    if (this && this.elements && this.elements.dialog) {
      if (this.elements.box.style.display !== 'none') {
        this.elements.box.style.display = 'none';
      }
      if (this.elements.dialog.style.display !== 'none') {
        this.elements.dialog.style.display = 'none';
      }
    }
  },

  update : function(messageStr, barPosition) {
    this.show();
    if (this && this.elements && this.elements.dialog) {
      var showCloseButton = true;
      if (this.elements.bar && (parseInt(barPosition) !== -1)) {
        barPosition = parseInt(barPosition, 10);
        if (barPosition >= 0 && barPosition <= 100) {
          this.elements.bar.style.width = barPosition.toString() + '%';
        } else if (barPosition > 100) {
          this.elements.bar.style.width = '100%';
        } else {
          this.elements.bar.style.width = '1%';
        }
        if (barPosition < 100 && barPosition > 0) {
          showCloseButton = false;
        }
      }
      if (messageStr) {
        this.elements.dialogMessage.nodeValue = messageStr;
      }
      this.elements.button.style.display = showCloseButton ? '' : 'none';
    }
  }
};
