jQuery(function ($) {

  function isHidden(el) {
    var display = el.css('display');
    return (display === 'none')
  }

// case-insensitive :contains
  $.expr[':'].containsCaseInsensitive = function (a, i, m) {
    return $(a).text().toUpperCase()
      .indexOf(m[3].toUpperCase()) >= 0;
  };

// -- INIT --

  $('.date-content').hide();
  $('#close-all').hide();
  $('#map-container').hide();

  // -- TOGGLE ALL --

  $('.toggle-all').on('click', function () {
    if (isHidden($('#close-all'))) {
      $('.date-content').show();
      $('#close-all').show();
      $('#expand-all').hide();
    } else {
      $('.date-content').hide();
      $('#close-all').hide();
      $('#expand-all').show();
    }
  });

  // -- TOGGLE DATE --

  $('.date-header').on('click', function () {
    var content = $(this).siblings('.date-content')
    var menuHeight = $('#nav-custom').height();

    $('html,body').animate({
      scrollTop: $(this).offset().top - menuHeight
    }, 500);

    if (isHidden(content)) {
      content.slideDown();
    } else {
      content.slideUp();
    }
  });

  // -- SEARCH --

  $('.search').on('keyup', function () {
    var search = $(this).val();
    var events = $('.event');
    var results = $('.event:containsCaseInsensitive(' + search + ')');

    $('.date-content').show();
    $('.instructions').hide();
    events.hide().addClass('hidden');
    results.show().removeClass('hidden');

    $('.date').each(function () {
      if ($(this).find('.hidden').length == $(this).find('.event').length) {
        $(this).hide()
        $(this).addClass('hidden')
      } else {
        $(this).show()
        $(this).removeClass('hidden')
      }
    });

    if (search === '') {
      $('.date-content').hide();
      $('.instructions').show();

    }
//
//    if ($('.date-events-container.hidden').length == $('.date-events-container').length) {
//      $('.event-list-container').hide();
//      $('.no-events-container').show();
//    } else {
//      $('.event-list-container').show();
//      $('.no-events-container').hide();
//    }
  });

// -- MAP --

  var buildMap = function (venue) {

    var lat = venue.location.split(",")[0];
    var lng = venue.location.split(",")[1];

    var center = new google.maps.LatLng(lat, lng);
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
      animation: google.maps.Animation.DROP,
      map: map
    });

//    marker.setMap(map);

    var venueInfo = '<div class="info-window">' +
      '<p class="title"><h3>' + venue.name + '</h3><br>' + venue.size + '</p>' +
      '<p class="info">' + venue.address + '<br>' + venue.price +
      '<a href="' + venue.site + '">Site</a></p>' +
      '<div class="triangle"></div>';

    google.maps.event.addListener(marker, 'click', function () {
      infowindow.setContent(venueInfo);
      infowindow.open(map, marker);
    });

    google.maps.event.addDomListener(window, 'resize', function () {
      map.setCenter(center);
    });
  };

  function openMapModal(venue) {
    buildMap(venue);
    $('#map-container').modal({
//      closeHTML: '<i class="fa fa-times"></i>',
      overlayClose: true,
      autoResize: true,
      overlayCss: {
        background: 'rgba(22, 56, 91, 0.8)'
      },
      dataCss: {
        border: '2px solid #16385B'
      }
    })
  }


  $('.map-icon').on('click', function () {
    var id = $(this).data('venue-id');

    var promiseOfResult = $.getJSON("/venues/" + id + ".json");

    promiseOfResult.success(openMapModal);
  })
});

//if (document.body.scrollTop < window.innerHeight) {
//  $('.top').hide();
//} else {
//  $('.top').show();
//}
//
//$(window).on('scroll', function () {
//  if (document.body.scrollTop < window.innerHeight) {
//    $('.top').hide();
//  } else {
//    $('.top').show();
//  }
//});
//
//$('.top').on('click', function () {
//  $('html,body').animate({
//    scrollTop: $('header').offset().top
//  }, 500);
//});
//
//$('.cal-date').datepicker({
//  onSelect: function (dateText) {
//    dateText = dateText.toString().replace('/', '').replace('/', '');
//    $('html,body').animate({
//      scrollTop: $('#' + dateText + '').offset().top
//    }, 500);
//  }
//
//});