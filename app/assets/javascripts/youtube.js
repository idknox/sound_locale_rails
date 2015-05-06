function googleApiClientReady() {
  var apiKey = 'AIzaSyBRtL3pVPoD3YzPoEtd-b6bKB_SUpVsMgA';
  gapi.client.setApiKey(apiKey);
  gapi.client.load('youtube', 'v3').then(function () {
    loadTodayEvents();
  });
}

window.youtube = {
  initPlayer: function (query) {
    soundcloud.endPlayer();
    this.startPlayer(query);

    if (utils.isHidden($('#yt-player'))) {
      setTimeout(function () {
        $('#yt-player').slideToggle();
      }, 1000)
    }
  },

  startPlayer: function (query) {
    var yt = this;
    var request = gapi.client.youtube.search.list({
      q: query,
      part: 'snippet',
      type: 'video'
    });

    request.execute(function (response) {
      yt.videoIds = [];
      for (var i = 0; i < response.items.length; i++) {
        yt.videoIds.push(response.items[i].id.videoId);
      }
      yt.playVideo();
    });
  },

  playVideo: function () {
    var tag = document.createElement('script');

    tag.src = "https://www.youtube.com/iframe_api";
    var firstScriptTag = document.getElementsByTagName('script')[0];
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

    var url = "http://www.youtube.com/embed/" + this.videoIds[0] + "?enablejsapi=1&autoplay=1"
    $('#yt-video').attr('src', url);

    function onYouTubeIframeAPIReady() {
      var player = new YT.Player('#yt-video', {
        events: {
          'onReady': onPlayerReady
        }
      });
    }

    function onPlayerReady(event) {
      event.target.playVideo();
    }
  },

  expandVideo: function (minHeight, maxHeight) {
    var targetHeight = ($('#yt-video').height() === minHeight) ? maxHeight : minHeight;

    $('#yt-video').animate({
      height: targetHeight
    }, 500)
  },

  endPlayer: function () {
    if (!utils.isHidden($('#yt-player'))) {
      $('#yt-player').slideToggle();
      $('#yt-video').attr('src', '').css('height', 28);
    }
  }
};