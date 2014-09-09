// Custom case-insensitive :contains
$.expr[':'].containsCaseInsensitive = function (a, i, m) {
  return $(a).text().toUpperCase()
    .indexOf(m[3].toUpperCase()) >= 0;
};

$('.no-events-container').hide();
$('.search').on('keyup', function () {
  var search = $(this).val();
  var events = $('.date-event');
  var results = $('.date-event:containsCaseInsensitive(' + search + ')');

  events.hide();
  events.addClass('hidden');

  results.show();
  results.removeClass('hidden');

  $('.date-events-container').each(function () {
    if ($(this).find('.hidden').length == $(this).find('.date-event').length) {
      $(this).hide();
      $(this).addClass('hidden');
    } else {
      $(this).show();
      $(this).removeClass('hidden');
    }
  });

  if ($('.date-events-container.hidden').length == $('.date-events-container').length) {
    $('.event-list-container').hide();
    $('.no-events-container').show();
  } else {
    $('.event-list-container').show();
    $('.no-events-container').hide();
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