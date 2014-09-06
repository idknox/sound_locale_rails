function initialize() {
  var mapCanvas = document.getElementById('venues-map-container');
  if (!mapCanvas) {
    return;
  }

  var denver = new google.maps.LatLng(39.740009, -104.992302);

  var mapOptions = {
    center: denver,
    zoom: 11,
    disableDefaultUI: false,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  var map = new google.maps.Map(mapCanvas, mapOptions);

  var windowOptions = {
    boxClass: 'info-window',
    disableAutoPan: false,
    maxWidth: 300,
    maxHeight: 100,
    content: '',
    pixelOffset: new google.maps.Size(0, -190),
    shadowStyle: 1,
    padding: 20,
    boxStyle: {
      background: "#1C3C5B"
    },
    hideCloseButton: false,
    arrowSize: 10,
    arrowPosition: 30,
    arrowStyle: 2,
    closeBoxMargin: "5px 5px 2px 2px"
//    closeBoxURL: 'http://iconizer.net/files/Brightmix/orig/monotone_close_exit_delete.png'
  };

  var infowindow = new InfoBox(windowOptions);

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
        '<div class="venue-logo"><img src="' + venue.logo + '"/></div>' +
        '<p>'+ venue.address + '</p><p>' + venue.size + '</p><p>' + venue.price + '</p>' +
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

initialize();
