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
      // store the checkboxes for later actions
      this.fields.start = $(container).find('input[name$="[start]"]');
      this.fields.end = $(container).find('input[name$="[end]"]');

      var tabs = $('<div class="dialogControlButtons"/>').appendTo(container);

      this.pages.fields = $('<div class="dialogControlPage"/>').appendTo(container).hide();
      this.pages.in = $('<div class="dialogControlPage"/>').appendTo(container);
      this.pages.fromTo = $('<div class="dialogControlPage"/>').appendTo(container).hide();
      this.pages.from = $('<div class="dialogControlPage"/>').appendTo(container).hide();
      this.pages.to = $('<div class="dialogControlPage"/>').appendTo(container).hide();

      this.tabs.in = this.createTabButton('In', this.pages.in).appendTo(tabs);
      this.tabs.fromTo = this.createTabButton('From/To', this.pages.fromTo).appendTo(tabs);
      this.tabs.from = this.createTabButton('From', this.pages.from).appendTo(tabs);
      this.tabs.to = this.createTabButton('To', this.pages.to).appendTo(tabs);

      // move static inputs into "fields" tab
      this.pages.fields.append(this.fields.start);
      this.pages.fields.append(this.fields.end);

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
            return;
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

      this.switchTo(this.tabs.in, this.pages.in);
      this.updateFields();
    },

    createTabButton : function (caption, page) {
      var button = $('<button type="button" class="button">');
      button.text(caption);
      button.click(
        function(tab, page) {
          return function() {
            this.switchTo(tab, page);
          }.bind(this)
        }.bind(this)(button, page)
      );
      return button;
    },

    switchTo : function (tab, page) {
      var i;
      for (i in this.tabs) {
        if (!this.tabs.hasOwnProperty(i)) {
          continue;
        }
        this.tabs[i].removeAttr('data-selected');
      }
      for (i in this.pages) {
        if (!this.pages.hasOwnProperty(i)) {
          continue;
        }
        this.pages[i].hide();
      }
      this.currentPage = page;
      this.updateFields();
      tab.attr('data-selected', 'true');
      page.show();
    },

    updateFields : function() {
      if (this.currentPage === this.pages.from) {
        var start = this.inputs.from.val();
        if (start != '') {
          this.fields.start.val(start);
          var endDate = new Date();
          endDate.setFullYear(endDate.getFullYear() + 100);
          this.fields.end.val(getFormattedDate(endDate));
        }
      } else if (this.currentPage === this.pages.to) {
        var end = this.inputs.to.val();
        if (end != '') {
          this.fields.end.val(end);
          var startDate = new Date();
          startDate.setFullYear(startDate.getFullYear() - 100);
          this.fields.start.val(getFormattedDate(startDate));
        }
      } else {
        this.fields.start.val(this.inputs.start.val());
        this.fields.end.val(this.inputs.end.val());
      }
      console.log(this.fields.start.val(), this.fields.end.val());
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