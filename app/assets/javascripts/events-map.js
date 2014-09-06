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

  var windowOptions = {
    boxClass: 'info-window',
    disableAutoPan: false,
    maxWidth: 300,
    content: '',
    pixelOffset: new google.maps.Size(0, -190),
    shadowStyle: 1,
    padding: 20,
    boxStyle: {
      background: "#1C3C5B",
    },
    hideCloseButton: false,
    arrowSize: 10,
    arrowPosition: 30,
    arrowStyle: 2,
    closeBoxMargin: "5px 5px 2px 2px",
//    closeBoxURL: 'http://iconizer.net/files/Brightmix/orig/monotone_close_exit_delete.png'
  };

//  disableAutoPan: false,
//    maxWidth: 300,
//    pixelOffset: new google.maps.Size(0, -150),
//    zIndex: null,
//    boxStyle: {
//    background: "#1C3C5B",
//      opacity: 1,
//      width: "300px",
//      height: "100px"
//  },
//  closeBoxMargin: "10px 2px 2px 2px",
//    closeBoxURL: "http://www.google.com/intl/en_us/mapfiles/close.gif",
//    infoBoxClearance: new google.maps.Size(1, 1),
//    isHidden: false,
//    pane: "floatPane",
//    enableEventPropagation: false

  var infowindow = new InfoBox(windowOptions);

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
        $('.info-window').parent().parent().parent().addClass('info-window-all');
      });
    });
  };
  promiseOfResult.success(generateMarkers);
}
