function initialize() {
  var mapCanvas = document.getElementById('events-map-container');
  if (!mapCanvas) {
    return;
  }

  var denver = new google.maps.LatLng(39.740009, -104.992302);

  var mapOptions = {
    center: denver,
    zoom: 12,
    disableDefaultUI: true,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  var map = new google.maps.Map(mapCanvas, mapOptions);

  var infowindow = new google.maps.InfoWindow({});

  var promiseOfResult = $.getJSON("/");

  var generateMarkers = function (music_events) {
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
        '<p>' + music_event.name + '</p><br>' +
        '<p>' + music_event.venue.name + '</p><br>' +
        '<a href="' + music_event.tickets + '" class="button">Tickets</a>' +
        '</div>';

      google.maps.event.addListener(marker, 'click', function () {
        infowindow.setContent(eventInfo);
        infowindow.open(map, marker);
      });
    });
  };
  promiseOfResult.success(generateMarkers);
}
