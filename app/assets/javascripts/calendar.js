$('.cal-date').datepicker({
  onSelect: function (dateText) {
    dateText = dateText.toString().replace('/', '').replace('/', '');
    $('html,body').animate({
      scrollTop: $('#' + dateText + '').offset().top
    }, 500);
  }
});

$('.top').on('click', function() {
  $('html,body').animate({
    scrollTop: window
  }, 500);
});