$(document).ready(function () {

  // - GRID INDENT --

  var indented = 6;
  $.each($('.grid-event'), function (i, eventContainer) {
    if (i === indented) {
      $(this).addClass('hex-gap');
      indented += 11;
    }
  });

  // - FETCH MORE EVENTS --

  // Add events to container
  function addGridEvents(events) {
    $('#events-wait').hide();
    var indented = 0;
    $.each(events, function (i, event) {
      var indentClass = ' ';

      if (i === indented) {
        indentClass = 'hex-gap';
        indented += 11;
      }

      var newEvent = '<div class="hex grid-event ' + indentClass + '" style="background-image: url(' +
        event.image + ')"><div class="corner-1"></div><div class="corner-2"></div>' +
        '</div>';

      $('.events-grid').append(newEvent);
    })
  }

  // Get events from API
  function fetchMoreEvents() {
    var offset = $('.grid-event').length;

    var promiseOfResult = $.getJSON("/events/more/" + offset + ".json");
    promiseOfResult.success(addGridEvents);
  }

  // Scroll trigger
  $(window).on('scroll', function () {
    var trigger = $('.events-more').offset().top - $(window).height() + 100
    var w = $(window).scrollTop();

    if (w > trigger) {
      $('#events-wait').show();
      fetchMoreEvents();
    }
  })
});
