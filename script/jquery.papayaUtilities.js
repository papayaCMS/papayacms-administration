/**
* papaya Utility - extend jQuery with several utility methods
*/
(function($) {

  $.sizeToPixel = function (size, fullSize) {
    if (size.match(/%$/)) {
      var intSize = parseInt(size);
      return Math.floor(intSize * fullSize / 100);
    }
    return size;
  };

  /**
   *
   */
  $.fn.center = function() {
    this.each(
      function() {
        var node = $(this);
        var top = ($(window).height() - node.height()) / 2 + $(window).scrollTop();
        var left = ($(window).width() - node.width()) / 2 + $(window).scrollLeft();
        top = top > 0 ? top : 0;
        left = left > 0 ? left : 0;
        node.css(
          {
            position : 'absolute',
            top : top + "px",
            left : left + "px"
          }
        );
      }
    );
    return this;
  };

  $.waitUntil = function(condition, timeout) {
    var defer = $.Deferred();
    var step = 100;
    var timer = window.setInterval(
      function () {
        if (condition()) {
          window.clearInterval(timer);
          defer.resolve();
        }
        timeout -= step;
        if (timeout <= 0) {
          window.clearInterval(timer);
          defer.reject();
        }
      },
      step
    );
    return defer.promise();
  };

  /**
   * @param Function comparator
   * @param Function getSortable
   * @returns {Function}
   */
  $.fn.sortElements = function() {

    var sort = [].sort;

    return function(comparator, getSortable) {

      getSortable = getSortable || function(){return this;};

      var placements = this.map(

        function() {

          var sortElement = getSortable.call(this);
          var parentNode = sortElement.parentNode;

          // Since the element itself will change position, we have
          // to have some way of storing its original position in
          // the DOM. The easiest way is to have a 'flag' node:
          var nextSibling = parentNode.insertBefore(
            document.createTextNode(''),
            sortElement.nextSibling
          );

          return function() {

            if (parentNode === this) {
              throw new Error(
                "You can't sort elements if any one is a descendant of another."
              );
            }

            // Insert before flag:
            parentNode.insertBefore(this, nextSibling);
            // Remove flag:
            parentNode.removeChild(nextSibling);

          };
        }
      );

      return sort.call(this, comparator).each(
        function(i){
          placements[i].call(getSortable.call(this));
        }
      );
    };
  };
})(jQuery);
