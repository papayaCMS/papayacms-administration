/**
 * papaya Dialog Checkbox Buttons
 *
 * Adds button to select all/none or invert the selection of a group of checkboxes.
 */
(function($) {

  var getFormattedDate = function(dateValue) {
     return dateValue.getFullYear() + '-' +
      ("0"+(dateValue.getMonth() + 1)).slice(-2) + '-' +
      ("0"+dateValue.getDate()).slice(-2);
  };

  var datePickerOptions = {
    dateFormat: 'yy-mm-dd',
    changeYear: true,
    changeMonth: true
  };

  var papayaDialogDateRange = {

    fields : {},
    inputs : {},
    tabs : {},
    pages : {},
    currentPage: null,

    initialize : function(container) {
      var labels = $(container).data().labels || {};
      var selectedPage = $(container).data().selectedPage || 'fromto';

      // store the checkboxes for later actions
      this.fields.start = $(container).find('input[name$="[start]"]');
      this.fields.end = $(container).find('input[name$="[end]"]');

      var tabs = $('<div class="dialogControlButtons"/>').appendTo(container);

      this.pages.fields = $('<div class="dialogControlPage"/>').appendTo(container).hide();
      this.pages.fromTo = $('<div class="dialogControlPage"/>').appendTo(container)
      this.pages.in = $('<div class="dialogControlPage"/>').appendTo(container).hide();
      this.pages.from = $('<div class="dialogControlPage"/>').appendTo(container).hide();
      this.pages.to = $('<div class="dialogControlPage"/>').appendTo(container).hide();

      this.tabs.fromTo = this.createTabButton(
        'actions/date-filter-between',
        labels['page-fromto'] || 'From/To',
        'fromTo'
      ).appendTo(tabs);
      this.tabs.in = this.createTabButton(
        'actions/date-filter-period',
        labels['page-in'] || 'In (Year: YYYY, Year-Month: YYYY-MM)',
        'in'
      ).appendTo(tabs);
      this.tabs.from = this.createTabButton(
        'actions/date-filter-after',
        labels['page-from'] || 'From',
        'from'
      ).appendTo(tabs);
      this.tabs.to = this.createTabButton(
        'actions/date-filter-before',
        labels['page-to'] || 'To',
        'to'
      ).appendTo(tabs);

      // move static inputs into "fields" tab
      this.pages.fields.append(this.fields.start);
      this.pages.fields.append(this.fields.end);
      this.fields.mode = $('<input type="hidden"/>').appendTo(this.pages.fields);
      this.fields.mode.attr('name', this.fields.start.attr('name').replace(/\[start\]$/, '[mode]'));

      // create a new input for "in" tab
      this.inputs.in = $('<input class="dialogInput dialogScale" type="text"/>').appendTo(this.pages.in);
      var startMonth = this.fields.start.val().substr(0, 7);
      var endMonth = this.fields.end.val().substr(0, 7);
      if (startMonth === endMonth) {
        this.inputs.in.val(startMonth);
      } else {
        this.inputs.in.val(startMonth.substr(0, 4));
      }
      this.inputs.in.on(
        'change',
        function() {
          var year, startMonth, endMonth, startDate, endDate, start, end;
          var value = this.inputs.in.val();
          if (value.match(/^\d{4}-\d{1,2}/)) {
            year = parseInt(value.substr(0, 4));
            startMonth = endMonth = parseInt(value.substr(5)) - 1;
          } else if (value.match(/^\d{4}/)) {
            year = parseInt(value.substr(0, 4));
            startMonth = 0;
            endMonth = 11;
          } else {
            if (value == '') {
              this.inputs.start.val('');
              this.inputs.from.val('');
              this.inputs.end.val('');
              this.inputs.to.val('');
              return;
            }
          }
          startDate = (new Date(year, startMonth, 1, 0, 0, 1));
          endDate = (new Date(year, endMonth + 1, 0, 0, 0, 1));
          start = getFormattedDate(startDate);
          end = getFormattedDate(endDate);
          this.inputs.start.val(start);
          this.inputs.from.val(start);
          this.inputs.end.val(end);
          this.inputs.to.val(end);
          this.updateFields();
        }.bind(this)
      );

      // create the two inputs for the fromTo tab
      this.inputs.start = $('<input class="dialogInput dialogScale" type="text" autocomplete="off"/>').appendTo(this.pages.fromTo);
      this.inputs.start.val(this.fields.start.val());
      this.inputs.start.datepicker(datePickerOptions);
      this.inputs.start.on(
        'change',
        function() {
          if (this.currentPage === this.pages.fromTo) {
            this.inputs.from.val(this.inputs.start.val());
            this.updateFields();
          }
        }.bind(this)
      );
      this.inputs.end = $('<input class="dialogInput dialogScale" type="text" autocomplete="off"/>').appendTo(this.pages.fromTo);
      this.inputs.end.val(this.fields.end.val());
      this.inputs.end.datepicker(datePickerOptions);
      this.inputs.end.on(
        'change',
        function() {
          if (this.currentPage === this.pages.fromTo) {
            this.inputs.to.val(this.inputs.end.val());
            this.updateFields();
          }
        }.bind(this)
      );
      // create a new input for "from" tab
      this.inputs.from = $('<input class="dialogInput dialogScale" type="text" autocomplete="off"/>').appendTo(this.pages.from);
      this.inputs.from.val(this.fields.start.val());
      this.inputs.from.datepicker(datePickerOptions);
      this.inputs.from.on(
        'change',
        function() {
          if (this.currentPage === this.pages.from) {
            this.inputs.start.val(this.inputs.from.val());
            this.updateFields();
          }
        }.bind(this)
      );

      // create a new input for "to" tab
      this.inputs.to = $('<input class="dialogInput dialogScale" type="text" autocomplete="off"/>').appendTo(this.pages.to);
      this.inputs.to.val(this.fields.end.val());
      this.inputs.to.datepicker(datePickerOptions);
      this.inputs.to.on(
        'change',
        function() {
          if (this.currentPage === this.pages.to) {
            this.inputs.end.val(this.inputs.to.val());
            this.updateFields();
          }
        }.bind(this)
      );

      this.switchTo(selectedPage);
      this.updateFields();
    },

    createTabButton : function (glyph, text, pageName) {
      var button = $('<button type="button" class="button">');
      var image = $('<img/>').appendTo(button);
      image.attr(
        {
          src : './pics/icons/16x16/' + glyph + '.png',
          alt : text,
          title : text
        }
      );
      button.attr('title', text);
      button.click(
        function(pageName) {
          return function() {
            this.switchTo(pageName);
          }.bind(this)
        }.bind(this)(pageName)
      );
      return button;
    },

    switchTo : function (pageName) {
      var tab, page;
      if (this.tabs[pageName] && this.pages[pageName]) {
        tab = this.tabs[pageName];
        page = this.pages[pageName];
      } else {
        tab = this.tabs.fromTo;
        page = this.pages.fromTo;
      }
      var i;
      for (i in this.tabs) {
        if (!this.tabs.hasOwnProperty(i)) {
          continue;
        }
        this.tabs[i].removeClass('selected');
      }
      for (i in this.pages) {
        if (!this.pages.hasOwnProperty(i)) {
          continue;
        }
        this.pages[i].hide();
      }
      this.currentPage = page;
      this.fields.mode.val(pageName);
      this.updateFields();
      tab.addClass('selected');
      page.show();
    },

    updateFields : function() {
      if (this.currentPage === this.pages.from) {
        this.fields.end.val('');
      } else if (this.currentPage === this.pages.to) {
        this.fields.start.val('');
      } else {
        this.fields.start.val(this.inputs.start.val());
        this.fields.end.val(this.inputs.end.val());
      }
    }
  };

  $.fn.papayaDialogDateRange = function() {
    this.each(
      function() {
        var instance = jQuery.extend(true, {}, papayaDialogDateRange);
        instance.initialize(this);
      }
    );
    return this;
  };
})(jQuery);