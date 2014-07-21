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