jQuery(function ($) {

  $('#venue-modal-container').hide();

  var buildMap = function (venue) {

    var lat = venue.location.split(",")[0];
    var lng = venue.location.split(",")[1];

    var center = new google.maps.LatLng(lat, lng);
    var mapCanvas = document.getElementById('map');

    var mapOptions = {
      center: center,
      zoom: 13,
      scrollwheel: false,
      disableDefaultUI: true,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };

    var map = new google.maps.Map(mapCanvas, mapOptions);


    new google.maps.Marker({
      position: new google.maps.LatLng(lat, lng),
      title: venue.name,
      animation: google.maps.Animation.DROP,
      map: map
    });

    google.maps.event.addDomListener(window, 'resize', function () {
      map.setCenter(center);
    });
  };

  function openVenueModal(venue) {
    buildMap(venue);

    var directionsUrl = 'https://maps.google.com/maps?f=d&daddr=' + venue.address + '&saddr=' + localStorage.getItem('userOrigin');

    $('#content').append(
        '<div class="title header">' + venue.title + '</div>' + venue.address +
        '<div class="row"><div class="col-sm-2 col-sm-offset-5 events">' +
        '<a class="header" href="/?venue=' + venue.id + '">Events</a></div><div class="col-sm-8 col-sm-offset-2 info">' +
        '<div class="size">' + venue.size + '</div><div class="price">' +
        venue.price + '</div><div class="site"><a href="' + venue.site +
        '">Website</a></div><div class="directions"><a href="' + directionsUrl +
        '">Directions</a></div></div></div>'
    );
    $('#venue-modal-container').modal({
      overlayClose: true,
      autoResize: true,
      overlayCss: {
        background: 'rgba(22, 56, 91, 0.8)'
      }
    })
  }

  $('.venue').on('mouseenter', function () {
    $(this).find('.layer').css('background', 'rgba(22, 56, 91, 0.4)')
  }).on('mouseleave', function () {
    $(this).find('.layer').css('background', 'none')
  }).on('click', function () {
    $('#content, #map').empty();
    var id = $(this).data('venue-id');

    var promiseOfResult = $.getJSON("/venues/" + id + ".json");

    promiseOfResult.success(openVenueModal);
  });
});


//var venue = $('.venue-tile');
//
//var setMargin = function () {
//  var marginRight = venue.css('margin-right');
//  venue.css('margin-bottom', marginRight);
//  venue.css('margin-bottom', marginRight);
//};
//
//var setHeight = function () {
//  var width = venue.find('div').width();
//  var widthRatio = (parseFloat(width) * 0.56 ).toString();
//  venue.find('div').css({'height': widthRatio + 'px'});
//};
//
//$(window).on('resize', function () {
//  setMargin();
//  setHeight();
//});
//
//setMargin();
//setHeight();
