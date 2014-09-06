// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require refills
//= require jquery-ui


$(document).ready(function () {


  $(function () {
    $('.cal-date').datepicker({ dateFormat: "yy-mm-dd"});
  });
  
//  --- FLASH ---

  var stopFlash = function () {
    $('.flash').slideUp()
  };

  window.setTimeout(stopFlash, 5000);

//  --- EVENT FILTER ---

// Custom case-insensitive :contains
  $.expr[':'].containsCaseInsensitive = function (a, i, m) {
    return $(a).text().toUpperCase()
      .indexOf(m[3].toUpperCase()) >= 0;
  };

  $('.no-events-container').hide();
  $('.search').on('keyup', function () {
    var search = $(this).val();
    var events = $('.event-row');
    var results = $('.event-row:containsCaseInsensitive(' + search + ')');

    events.hide();
    events.addClass('hidden');

    results.show();
    results.removeClass('hidden');

    $('.event-date-container').each(function () {
      if ($(this).find('.hidden').length == $(this).find('.event-row').length) {
        $(this).hide();
        $(this).addClass('hidden');
      } else {
        $(this).show();
        $(this).removeClass('hidden');
      }
    });

    if ($('.event-date-container.hidden').length == $('.event-date-container').length) {
      $('.event-list-container').hide();
      $('.no-events-container').show();
    } else {
      $('.event-list-container').show();
      $('.no-events-container').hide();
    }

  });
  initialize();
});