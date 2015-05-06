window.googleMap = {
  buildVenueMap: function (venue) {

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
  },

  openModal: function (venue) {
    googleMap.buildVenueMap(venue);
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
};