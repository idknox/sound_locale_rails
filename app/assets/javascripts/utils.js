window.utils = {
  isHidden: function (el) {
    var display = el.css('display');
    return (display === 'none')
  },

  toggleHeight: function (el, minHeight, maxHeight) {
    var targetHeight = (el.height() === minHeight) ? maxHeight : minHeight;

    el.animate({
      height: targetHeight
    }, 500)
  }
};
