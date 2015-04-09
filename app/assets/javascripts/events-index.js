$(document).ready(function () {

// case-insensitive :contains
  $.expr[':'].containsCaseInsensitive = function (a, i, m) {
    return $(a).text().toUpperCase()
      .indexOf(m[3].toUpperCase()) >= 0;
  };

  function isHidden(el) {
    var display = el.css('display');
    return (display === 'none')
  }

//  $('.date-content').hide();

  $('.date-header').on('click', function () {
    var content = $(this).siblings('.date-content')

    if (isHidden(content)) {
      content.slideDown();
    } else {
      content.slideUp();
    }
  })


});


//$(function () {
//  $('.cal-date').datepicker({ dateFormat: "yy-mm-dd"});
//});
//
//$('.cal-date').datepicker({
//  onSelect: function (dateText) {
//    dateText = dateText.toString().replace('/', '').replace('/', '');
//    $('html,body').animate({
//      scrollTop: $('#' + dateText + '').offset().top
//    }, 500);
//  }
//});

// Custom case-insensitive :contains
//$.expr[':'].containsCaseInsensitive = function (a, i, m) {
//  return $(a).text().toUpperCase()
//    .indexOf(m[3].toUpperCase()) >= 0;
//};
//
//$('.no-events-container').hide();
$('.search').on('keyup', function () {
  var search = $(this).val();
  var events = $('.event');
  var results = $('.event:containsCaseInsensitive(' + search + ')');

  events.hide().addClass('hidden');
  results.show().removeClass('hidden');

  $('.date').each(function () {
    if ($(this).find('.hidden').length == $(this).find('.event').length) {
      $(this).hide()
      $(this).addClass('hidden')
    } else {
      $(this).show()
      $(this).removeClass('hidden')
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

//if (document.body.scrollTop < window.innerHeight) {
//  $('.top').hide();
//} else {
//  $('.top').show();
//}
//
//$(window).on('scroll', function () {
//  if (document.body.scrollTop < window.innerHeight) {
//    $('.top').hide();
//  } else {
//    $('.top').show();
//  }
//});
//
//$('.top').on('click', function () {
//  $('html,body').animate({
//    scrollTop: $('header').offset().top
//  }, 500);
//});
//
//$('.cal-date').datepicker({
//  onSelect: function (dateText) {
//    dateText = dateText.toString().replace('/', '').replace('/', '');
//    $('html,body').animate({
//      scrollTop: $('#' + dateText + '').offset().top
//    }, 500);
//  }
//
//});