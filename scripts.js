

    var denver = new google.maps.LatLng(39.740009, -104.992302)

    var venues = [
      new google.maps.LatLng(39.733536, -104.992615),
      new google.maps.LatLng(39.715093, -104.983796),
      new google.maps.LatLng(39.740398, -104.975266),
      new google.maps.LatLng(39.760044, -104.983940)
    ];

    var markers = [];
    var iterator = 0;

    function initialize() {

      var mapCanvas = document.getElementById('map_container');
      var mapOptions = {
        center: denver,
        zoom: 11,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      }

      var map = new google.maps.Map(mapCanvas, mapOptions);

      var home = new google.maps.Marker({
        position: new google.maps.LatLng(39.715093, -104.983796),
        title: "Home",
        animation: google.maps.Animation.DROP,
        map: map
      });

      var galv = new google.maps.Marker({
        position: new google.maps.LatLng(39.733536, -104.992615),
        title: "Galvanize",
        animation: google.maps.Animation.DROP,
        icon: "images/galv.png",
        map: map
      });

      home.setMap(map);
      galv.setMap(map);

      var galv_desc = '<div id="content">' +
            '<div id="siteNotice">' +
                '</div>' +
            '<h1>Galvanize</h1>' +
            '<div>' +
                '<p><b>Galvanize</b> is a Denver-based startup focused on coalescing ' +
                    'communities of early stage technology companies through the ' +
                    'three pillars of Community, Curriculum and Capital. The first ' +
                    'Galvanize facility, located in the 30,000 sf historic Rocky ' +
                    'Mountain Bank Note Company building, was launched in November ' +
                    '2012. More than 150 companies are currently located at Galvanize, ' +
                    'establishing a nexus for the startup community in the region.</p> ' +
                '<p><a href="http://en.wikipedia.org/w/index.php?title=Uluru&oldid=297882194">' +
                    'Website</a></p>' +
                '</div>' +
            '</div>';

      var infowindow = new google.maps.InfoWindow({
        content: galv_desc
      });

    }

    google.maps.event.addDomListener(window, 'load', initialize);

