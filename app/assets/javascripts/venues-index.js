var venue = $('.venue-tile');

var setMargin = function () {
  var marginRight = venue.css('margin-right');
  venue.css('margin-bottom', marginRight);
  venue.css('margin-bottom', marginRight);
};

var setHeight = function () {
  var width = venue.find('div').width();
  var widthRatio = (parseFloat(width) * 0.56 ).toString();
  venue.find('div').css({'height': widthRatio + 'px'});
};

$(window).on('resize', function () {
  setMargin();
  setHeight();
});

setMargin();
setHeight();
