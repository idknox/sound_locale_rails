// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_tree ../../../vendor/assets/javascripts/.

$(document).ready(function () {
  if (localStorage.getItem('firstVisit') !== 'true') {
    localStorage.setItem('firstVisit', 'true');

    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(getOrigin);
    } else {
      localStorage.setItem('userOrigin', '')
    }

    function getOrigin(origin) {

      var originLat = origin.coords.latitude;
      var originLong = origin.coords.longitude;

      localStorage.setItem('userOrigin', 'loc:' + originLat + '+' + originLong);
    }
  }
});