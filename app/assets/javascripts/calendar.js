$('.cal-date').datepicker({
  onSelect: function (dateText) {
    dateText = dateText.toString().replace('/', '').replace('/', '');
    $('html,body').animate({
      scrollTop: $('#' + dateText + '').offset().top
    }, 500);
//    dateText = dateText.toString().replace('/', '').replace('/', '');
//    $('.event-date-container').hide();
//    $('#' + dateText + '').show();
  }
});

$('.top').hide();

$(window).on('scroll', function () {
  if ($(this).scrollTop != 0) {
    $('.top').show();
  }
});

$('.top').on('click', function () {
  $('html,body').animate({
    scrollTop: window
  }, 500);
  $(this).hide();
//  $('.event-date-container').show();
});