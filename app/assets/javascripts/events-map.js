var buildMap = function (music_events) {
  var mapCanvas = document.getElementById('events-map-container');
  if (!mapCanvas) {
    return;
  }

  var denver = new google.maps.LatLng(39.740009, -104.992302);

  var mapOptions = {
    center: denver,
    zoom: 11,
    disableDefaultUI: true,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  var map = new google.maps.Map(mapCanvas, mapOptions);

  var windowOptions = {
    disableAutoPan: false,
    content: '',
    pixelOffset: new google.maps.Size(-144, -195),
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

    var eventInfo = '<div class="info-window">' +
      '<p class="title">' + music_event.name + '<br>' + music_event.venue.title + '</p>' +
      '<p class="info">' + music_event.venue.address + '<br>' + music_event.time +
      '<a href="' + music_event.tickets + '">Tickets</a></p>' +
      '<div class="triangle"></div>';

    google.maps.event.addListener(marker, 'click', function () {
      infowindow.setContent(eventInfo);
      infowindow.open(map, marker);
    });
  });

  google.maps.event.addDomListener(window, 'resize', function () {
    map.setCenter(lat, lng);
  });

};

var promiseOfResult = $.getJSON("/events/map.json");
promiseOfResult.success(buildMap);

// DATE SWITCH

var today = $('#today');
var tomorrow = $('#tomorrow');
var calTrigger = $('#cal-date-trigger');
var cal = $('#cal-date');

today.on('click', function () {
  var promiseOfResult = $.getJSON("/events/map.json");
  promiseOfResult.success(buildMap);
});

tomorrow.on('click', function () {
  var dateData = {date: 'tomorrow'};
  var promiseOfResult = $.getJSON("/events/map.json", dateData);
  promiseOfResult.success(buildMap);
});

calTrigger.on('click', function () {
  cal.show();
  cal.datepicker({
    dateFormat: "mm.dd.yy",
    onSelect: function (dateText) {
      cal.hide();
      calTrigger.addClass('active');
      calTrigger.parent().siblings().children().removeClass('active');
      var filteredDate = {date: dateText};
      calTrigger.empty();
      calTrigger.append(dateText);
      var promiseOfResult = $.getJSON("/", filteredDate);
      promiseOfResult.success(buildMap);
    }
  });
});

// ACTIVE BUTTONS

today.on('click', function () {
  cal.hide();
  $(this).addClass('active');
  $(this).parents().siblings().children().removeClass('active');
});

tomorrow.on('click', function () {
  $('#cal-date').hide();
  $(this).addClass('active');
  $(this).parents().siblings().children().removeClass('active');
});

// HIDES CAL

$('html').click(function () {
  cal.hide();
});

calTrigger.click(function (event) {
  event.stopPropagation();
});