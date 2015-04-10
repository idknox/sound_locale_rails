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

//    closeBoxURL: 'http://iconizer.net/files/Brightmix/orig/monotone_close_exit_delete.png'
  };

  var infowindow = new InfoBox(windowOptions);

  var promiseOfResult = $.getJSON("/venues/map.json");

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

      var directionsUrl = 'https://maps.google.com/maps?f=d&daddr=' + venue.address + '&saddr=' + localStorage.getItem('userOrigin');

      var venueInfo = '<div class="info-window"><div class="row"><div class="col-sm-10 col-sm-offset-1 content">' +
        '<div class="title"><h2>' + venue.title + '</h2>' + venue.address + '</div><br><br><div class="size">' + venue.size + '</div><div class="price">' + venue.price +
        '</div><div class="site"><a href="' + venue.site + '">Website</a></div><div class="directions"><a href="' + directionsUrl + '">Directions</a></div></p>' +
        '</div></div><div class="triangle"></div></div>';

      google.maps.event.addListener(marker, 'click', function () {
        infowindow.setContent(venueInfo);
        infowindow.open(map, marker);
      });

      google.maps.event.addDomListener(window, 'resize', function () {
        map.setCenter(denver);
      });
    });
  };
  promiseOfResult.success(generateMarkers);
}

initialize();
