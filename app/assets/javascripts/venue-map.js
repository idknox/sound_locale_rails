function initialize() {
  var mapCanvas = document.getElementById('venue-map-container');
  if (!mapCanvas) {
    return;
  }
  var id = $('.venue-info-container').data("id");
  var promiseOfResult = $.getJSON("/venues/" + id);

  var buildMap = function (venue) {
    var lat = venue.location.split(",")[0];
    var lng = venue.location.split(",")[1];

    var center = new google.maps.LatLng(lat, lng);

    var mapOptions = {
      center: center,
      zoom: 12,
      disableDefaultUI: false,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };

    var map = new google.maps.Map(mapCanvas, mapOptions);

    var marker = new google.maps.Marker({
      position: new google.maps.LatLng(lat, lng),
      title: venue.name,
      animation: google.maps.Animation.DROP,
      map: map
    });

    marker.setMap(map);
  };
  google.maps.event.addDomListener(window, 'resize', function () {
    map.setCenter(center);
  });
  promiseOfResult.success(buildMap);
}

initialize();

var setHeight = function () {
  var width = $('#venue-map-container').width();
  $('#venue-map-container').css({'height': width + 'px'});
};

setHeight();

$(window).on('resize', function () {
  setHeight();
});

if ($('#venue-events').find('li').length == 0) {
  $('#no-venue-events-container').show();
  $('.venue-events-container').hide();
} else {
  $('#no-venue-events-container').hide();
  $('.venue-events-container').show();
}




