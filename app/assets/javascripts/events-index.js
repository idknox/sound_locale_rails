// -- EVENT ACTIONS --

$('body').on('click', '.map-trigger', function () {
  $('#map-container').empty();
  var id = $(this).data('venue-id');

  var promiseOfResult = $.getJSON("/venues/" + id + ".json");
  promiseOfResult.success(googleMap.openModal);
});

$('body').on('click', '.yt-trigger', function () {
  var query = $(this).data('query');
  youtube.initPlayer(query);
});

$('body').on('click', '.sc-trigger', function () {
  var trackUrl = $(this).data('scUrl');
  soundcloud.startPlayer(trackUrl);
});

$('#yt-close').on('click', function () {
  youtube.endPlayer();
});

$('#yt-video-expand').on('click', function () {
  youtube.expandVideo(28, 200)
});

$('#sc-close').on('click', function () {
  soundcloud.endPlayer()
});

// -- VIEWS --

if (localStorage.getItem('eventView') == 'grid' && $(window).width() > 992) {
  eventUi.displayGrid();
} else {
  eventUi.displayList();
}

$('.expand').find('a').on('mouseenter', function () {
  var view = $(this).data('view');
  $(this).siblings('#' + view).show()
}).on('mouseleave', function () {
  var view = $(this).data('view');
  $(this).siblings('#' + view).hide()
});

$('#grid-trigger').on('click', function () {
  eventUi.displayGrid();
});

$('#list-trigger').on('click', function () {
  eventUi.displayList();
});

// -- TOGGLE DATES --

//$('.toggle-all').on('click', function () {
//  if (utils.isHidden($('#close-all'))) {
//    eventUi.displayAll()
//  } else {
//    eventUi.closeAll()
//  }
//});

// -- VENUE EVENTS --

if (window.location.search.indexOf('?venue=') > -1) {
  eventUi.displayFiltered();
  displayVenue()
}

function displayVenue() {
  var id = window.location.search.split('=')[1];

  $.getJSON("/venues/" + id + ".json").success(function (venue) {
    $('.events-title').empty().append(venue.name).show()

  })
}

// -- OPEN DATE --

$('.date-header').on('click', function () {
  var header = $(this);
  eventUi.expandAndFillDate(header);
});

// -- SCROLL TO MONTH --

$('.month').on('click', function () {
  var month = $(this).data('month');
  eventUi.scrollToMonth(month);
});

// -- STICKY DATE --

$(window).scroll(function () {
  $('.date').each(function () {
    var t = $(this).offset().top;
    var h = $('#nav-custom').height();
    var d = $(this).height();
    var w = $(window).scrollTop();

    if (w > t - h - 5 && w < t - h + d && eventUi.stickyDate) {
      $(this).find('.date-header').addClass('stuck')
    } else {
      $(this).find('.date-header').removeClass('stuck')
    }
  })
});

// -- CASE-INSENSITIVE SEARCH --

$.expr[':'].containsCaseInsensitive = function (a, i, m) {
  return $(a).text().toUpperCase()
    .indexOf(m[3].toUpperCase()) >= 0;
};

// -- SEARCH --

$('.search').on('keyup', function () {
  var search = $(this).val();
  var events;
  var results;

  if (localStorage.getItem('eventView') == 'grid') {
    events = $('.grid-event');
    results = $('.grid-event:containsCaseInsensitive(' + search + ')');

    if (search === '') {
      $('.grid-container').show();
    }
  } else {
    events = $('.event');
    results = $('.event:containsCaseInsensitive(' + search + ')');
    eventUi.displayFiltered();

    if (search === '') {
      $('.date-content').hide();
      $('.months, .toggle-all').show();
      $('.expand').empty().append('Click Date to Expand <i class="fa fa-caret-down"></i>')
    }
  }
  events.hide().addClass('hidden');
  results.show().removeClass('hidden');


  $('.date').each(function () {
    if ($(this).find('.hidden').length === $(this).find('.event').length) {
      $(this).hide();
    } else {
      $(this).show();
    }
  });

  if ($('.events').find('.hidden').length === $('.events').find('.event').length) {
    $('.date, .months').hide();
    $('.no-events').show();
  } else if ($('.grid-container').find('.hidden').length === $('.grid-container').find('.grid-event').length) {
    $('.grid-container').hide();
    $('.no-events').show();
  }
  else {
    $('.no-events').hide();
  }
});