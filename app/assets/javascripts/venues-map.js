function initialize() {
  var mapCanvas = document.getElementById('venues-map-container');
  if (!mapCanvas) {
    return;
  }

  var denver = new google.maps.LatLng(39.740009, -104.992302);

  var mapOptions = {
    center: denver,
    zoom: 12,
    disableDefaultUI: true,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }

  var map = new google.maps.Map(mapCanvas, mapOptions);

  var infowindow = new google.maps.InfoWindow({});

  var promiseOfResult = $.getJSON("/venues/map");

  var generateMarkers = function (venues) {
    $.each(venues, function (i, venue) {

      var lat = venue.location.split(",")[0];
      var lng = venue.location.split(",")[1];

      var marker = new google.maps.Marker({
        position: new google.maps.LatLng(lat, lng),
        title: venue.name,
        animation: google.maps.Animation.DROP,
        map: map
      });

      var venueInfo = '<div class="info-window">' +
        '<img src="' + venue.logo + '"/>' +
        '<p>' + venue.size + '</p><p>' + venue.price + '</p>' +
        '<a href="' + venue.site + '" class="button">Tickets</a>' +
        '</div>';

      google.maps.event.addListener(marker, 'click', function () {
        infowindow.setContent(venueInfo);
        infowindow.open(map, marker);
      });
    });
  };
  promiseOfResult.success(generateMarkers);
}