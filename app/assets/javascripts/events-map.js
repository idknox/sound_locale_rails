var buildMap = function (music_events) {
  var mapCanvas = document.getElementById('events-map-container');
  if (!mapCanvas) {
    return;
  }

  var denver = new google.maps.LatLng(39.740009, -104.992302);

  var mapOptions = {
    center: denver,
    zoom: 10,
    disableDefaultUI: true,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  var map = new google.maps.Map(mapCanvas, mapOptions);

  var windowOptions = {
    disableAutoPan: false,
    content: '',
    pixelOffset: new google.maps.Size(-144, -240),
    shadowStyle: 1,
    hideCloseButton: false,
    arrowSize: 10,
    arrowPosition: 30,
    arrowStyle: 2,
    closeBoxMargin: "5px 5px 5px 5px",
    closeBoxURL: 'http://i.imgur.com/UVVEq19.png'
  };

  var infowindow = new InfoBox(windowOptions);

  $.each(music_events, function (i, music_event) {

    var lat = music_event.venue.location.split(",")[0];
    var lng = music_event.venue.location.split(",")[1];

    var marker = new google.maps.Marker({
      position: new google.maps.LatLng(lat, lng),
      title: music_event.name,
      animation: google.maps.Animation.DROP,
      map: map
    });

    var directionsUrl = 'https://maps.google.com/maps?f=d&daddr=' +
      music_event.venue.address + '&saddr=' + localStorage.getItem('userOrigin');

    var opener = music_event.opener || '';

    var eventInfo = '<div class="info-window"><div class="row">' +
      '<div class="col-sm-10 col-sm-offset-1 content">' +
      '<div class="title"><h2>' + music_event.headliner + '</h2>' +
      opener + '<br></div><div class="venue">' + music_event.venue.name +
      '</div><br><div class="event-price">' + music_event.price + '</div><br>' +
      '<div class="price">' + (new Date(music_event.time)).format('h:MM TT') +
      '</div><div class="site"><a href="' + music_event.tickets + '">Tickets' +
      '</a></div><div class="directions"><a href="#" data-url="' + directionsUrl +'">' +
      'Directions</a></div></p></div></div><div class="triangle"></div></div>';

    google.maps.event.addListener(marker, 'click', function () {
      infowindow.setContent(eventInfo);
      infowindow.open(map, marker);
    });
  });

  google.maps.event.addDomListener(window, 'resize', function () {
    map.setCenter(denver);
  });

};

var promiseOfResult = $.getJSON("/events/map.json");
promiseOfResult.success(buildMap);


function activate(el) {
  el.parents().siblings('.date-select').find('span, #date-select').removeClass('active')
  el.find('span').addClass('active')
}

$('#today').on('click', function () {
  var dateData = {date: new Date};
  activate($(this))
  var promiseOfResult = $.getJSON("/events/map.json", dateData);
  promiseOfResult.success(buildMap);
});

$('#tomorrow').on('click', function () {
  var dateData = {date: 'tomorrow'};
  activate($(this));
  var promiseOfResult = $.getJSON("/events/map.json", dateData);
  promiseOfResult.success(buildMap);

});

$('#date-select').on('change', function () {
  var dateData = {date: $(this).val()};
  $(this).addClass('active').parents().siblings('.date-select').find('span').removeClass('active')
  var promiseOfResult = $.getJSON("/events/map.json", dateData);
  promiseOfResult.success(buildMap);
});

$('body').on('click', '.directions', function () {
  console.log('hi')
  var url = $(this).data('url');
  openInNewTab(url)
});

function openInNewTab(url) {
  var win = window.open(url, '_blank');
  win.focus();
}