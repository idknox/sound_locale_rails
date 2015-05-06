//jQuery(function ($) {

// -- PLAYERS --

$('body').on('click', '.yt-trigger', function () {
  var query = $(this).data('query');
  youtube.initPlayer(query);
});


$('#yt-close').on('click', function () {
  youtube.endPlayer();
});

$('#yt-video-expand').on('click', function () {
  youtube.expandVideo(28, 200)
});

$('body').on('click', '.sc-trigger', function () {
  var trackUrl = $(this).data('scUrl');
  soundcloud.startPlayer(trackUrl);
});

$('#sc-close').on('click', function () {
  soundcloud.endPlayer()
});

// CASE-INSENSITIVE CONTAINS

$.expr[':'].containsCaseInsensitive = function (a, i, m) {
  return $(a).text().toUpperCase()
    .indexOf(m[3].toUpperCase()) >= 0;
};

// -- INIT --

function displayGrid() {
  $('.events-list, .toggle-all').hide();
  $('.grid-container, .grid-instructions').show();
  localStorage.setItem('eventView', 'grid');
}

function displayList() {
  $('.grid-container, .grid-instructions').hide();
  $('.events-list, .toggle-all').show();
  $('.date-content').first().show();
  localStorage.setItem('eventView', 'list');
}

if (localStorage.getItem('eventView') == 'grid' && $(window).width() > 992) {
  displayGrid();
} else {
  displayList();
}


// -- VIEWS --

$('.expand').find('a').on('mouseenter', function () {
  var view = $(this).data('view');
  $(this).siblings('#' + view).show()
}).on('mouseleave', function () {
  var view = $(this).data('view');
  $(this).siblings('#' + view).hide()
});

$('#grid-trigger').on('click', function () {
  displayGrid();
});

$('#list-trigger').on('click', function () {
  displayList();
});

// -- TOGGLE DATES --

var stickyDate;

function displayAll() {
  $('.date-content, #close-all').show();
  $('#expand-all').hide();
  stickyDate = true;
}

function displayFiltered() {
  $('.date-content').show();
  $('.toggle-all').hide();
  $('.expand').empty().append('\u00a0');
  stickyDate = false;
}

function closeAll() {
  $('.date-content, #close-all').hide();
  $('#expand-all').show();
  stickyDate = false;
}

function displayVenue() {
  var id = window.location.search.split('=')[1];

  $.getJSON("/venues/" + id + ".json").success(function (venue) {
    $('.events-title').empty().append(venue.name).show()
  })
}

$('.toggle-all').on('click', function () {
  if (utils.isHidden($('#close-all'))) {
    displayAll()
  } else {
    closeAll()
  }
});

// -- VENUE EVENTS --

if (window.location.search.indexOf('?venue=') > -1) {
  displayFiltered();
  displayVenue()
}

// -- INIT TODAY'S EVENTS --
function loadTodayEvents() {
  var today = $('.date-header').first().siblings('.date-content');
  var timestamp = new Date();
  var date = new Date(timestamp.getFullYear(), timestamp.getMonth(), timestamp.getDate());
  $.get('/events/date/' + date, {}, function (events) {
    insertEvents(today, events);
  });
}
// -- OPEN DATE --

$('.date-header').on('click', function () {
  var header = $(this);
  var content = header.siblings('.date-content');
  var headerDate = header.data('date');
  var menuHeight = $('#nav-custom').height();

  var timestamp = new Date(headerDate);
  var date = new Date(timestamp.getFullYear(), timestamp.getMonth(), timestamp.getDate());

  $.get('/events/date/' + date, {}, function (events) {
    insertEvents(content, events);

    $('html,body').animate({
      scrollTop: header.offset().top - menuHeight
    }, 500);

    content.slideToggle();

  });
});


// -- INSERT EVENTS --
function insertEvents(container, events) {
  $.each(events, function (i, event) {

    var opener = event.opener || '';

    var event = '<div class="event clear"><div class="col-xs-12 col-md-5 title">' +
      '<div class="headliner">' + event.headliner + '</div>' +
      '<div class="opener">' + opener + '</div></div><div class="col-xs-12 ' +
      'col-md-5 info">' + 'Event time' + ' @ <a href="/venues/' + event.venue.id +
      '" class="body-link">' + event.venue.name + '</a><div class="price">' +
      event.price + '</div></div><div class="col-xs-12 col-md-2 links">' +
      '<div class="row"><div class="col-xs-3"><a class="tickets-trigger" href="' + event.tickets + '"><i class="fa fa-ticket ' +
      '"></i></a></div><div class="col-xs-3">' +
      '<i class="fa fa-map-marker map-trigger" data-venue-id="' + event.venue.id +
      '"></i></div><div class="col-xs-3"><i class="fa fa-youtube-play yt-trigger"' +
      'data-query="' + event.headliner + ' band"></i></div><div class="col-xs-3">' +
      '<i class="fa fa-soundcloud sc-trigger" data-query="' + event.headliner +
      '"></i></div></div></div></div></div>';

    showScButton(container);
    container.append(event);
  })
}

function showScButton(date) {
  date.find('.sc-trigger').each(function (i, el) {
    var trigger = $(this);
    var query = trigger.data('query');
    var storedDate = localStorage.getItem(query);

    if (!storedDate) {

      SC.get('/users', {q: query, limit: 1}, function (users) {

        if (users.length > 0) {
          var userId = users[0].id;

          SC.get('/users/' + userId + '/tracks', {limit: 1}, function (tracks) {
            localStorage[query] = tracks[0].permalink_url;
            trigger.show();
            trigger.data('scUrl', localStorage[query]);
          })
        } else {
          localStorage[query] = 'false';
        }
      });
    } else if (storedDate && storedDate !== 'false') {
      trigger.show();
      trigger.data('scUrl', storedDate)
    }
  });
}

// -- SCROLL TO MONTH --

$('.month').on('click', function () {
  var month = $(this).data('month');

  $('html,body').animate({
    scrollTop: $('#' + month).offset().top - $('#nav-custom').height()
  }, 500);
});

// -- STICKY DATE --

$(window).scroll(function () {
  $('.date').each(function () {
    var t = $(this).offset().top;
    var h = $('#nav-custom').height();
    var d = $(this).height();
    var w = $(window).scrollTop();

    if (w > t - h - 5 && w < t - h + d && stickyDate) {
      $(this).find('.date-header').addClass('stuck')
    } else {
      $(this).find('.date-header').removeClass('stuck')
    }
  })
});

// -- SEARCH --

$('.search').on('keyup', function () {
  var search = $(this).val();
  var events = $('.event');
  var results = $('.event:containsCaseInsensitive(' + search + ')');

  displayFiltered();

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
  } else {
    $('.no-events').hide();
  }

  if (search === '') {
    $('.date-content').hide();
    $('.months, .toggle-all').show();
    $('.expand').empty().append('Click Date to Expand <i class="fa fa-caret-down"></i>')
  }
});

// -- MAP --

var buildMap = function (venue) {

  var lat = venue.location.split(",")[0];
  var lng = venue.location.split(",")[1];
  var centerLat = parseFloat(lat) + 0.005;

  var center = new google.maps.LatLng(centerLat, lng);
  var mapCanvas = document.getElementById('map-container');

  var mapOptions = {
    center: center,
    zoom: 14,
    scrollwheel: false,
    disableDefaultUI: true,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  var map = new google.maps.Map(mapCanvas, mapOptions);

  var windowOptions = {
    disableAutoPan: false,
    content: '',
    pixelOffset: new google.maps.Size(-144, -225),
    shadowStyle: 1,
    hideCloseButton: false,
    arrowSize: 10,
    arrowPosition: 30,
    arrowStyle: 2,
    closeBoxMargin: "5px 5px 5px 5px",
    closeBoxURL: 'http://i.imgur.com/UVVEq19.png'
  };

  var infowindow = new InfoBox(windowOptions);

  var marker = new google.maps.Marker({
    position: new google.maps.LatLng(lat, lng),
    title: venue.name,
    map: map
  });

  var directionsUrl = 'https://maps.google.com/maps?f=d&daddr=' + venue.address + '&saddr=' + localStorage.getItem('userOrigin');

  var venueInfo = '<div class="info-window"><div class="row"><div class="col-sm-10 col-sm-offset-1 content">' +
    '<div class="title"><h2>' + venue.title + '</h2>' + venue.address + '</div><br><br><div class="size">' + venue.size + '</div><div class="price">' + venue.price +
    '</div><div class="site"><a href="' + venue.site + '">Website</a></div><div class="directions"><a href="' + directionsUrl + '">Directions</a></div></p>' +
    '</div></div><div class="triangle"></div></div>';

  infowindow.setContent(venueInfo);
  infowindow.open(map, marker);

  google.maps.event.addDomListener(window, 'resize', function () {
    map.setCenter(center);
  });
};

function openMapModal(venue) {
  buildMap(venue);
  $('#map-container').modal({
    overlayClose: true,
    closeHTML: '<i class="fa fa-times fa-2x"</i>',
    closeClass: 'modal-close',
    autoResize: true,
    containerCss: {
      height: '90%',
      width: '100%'
    },
    overlayCss: {
      background: 'rgba(22, 56, 91, 0.8)'
    },
    dataCss: {
      border: '2px solid #16385B'
    }
  })
}

$('.map-trigger').on('click', function () {
  $('#map-container').empty();
  var id = $(this).data('venue-id');

  var promiseOfResult = $.getJSON("/venues/" + id + ".json");

  promiseOfResult.success(openMapModal);
});
//});