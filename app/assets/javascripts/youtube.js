function googleApiClientReady() {
  var apiKey = 'AIzaSyBRtL3pVPoD3YzPoEtd-b6bKB_SUpVsMgA';
  gapi.client.setApiKey(apiKey);
  gapi.client.load('youtube', 'v3').then(function () {
    $('.yt-trigger').show()
  });
}

$(document).ready(function () {
  var videoIds = [];
  var player;

  $('.yt-trigger').on('click', function () {
    var query = $(this).data('query');

    startPlayer(query);
    if (utils.isHidden($('.video-container'))) {
      setTimeout(function () {
        $('.video-container').slideToggle();
      }, 1000)
    }

  });

  function startPlayer(query) {
    var request = gapi.client.youtube.search.list({
      q: query,
      part: 'snippet',
      type: 'video'
    });

    request.execute(function (response) {
      videoIds = [];
      for (var i = 0; i < response.items.length; i++) {
        videoIds.push(response.items[i].id.videoId);
      }
      playVideo();
    });
  }

  function playVideo() {
    var tag = document.createElement('script');

    tag.src = "https://www.youtube.com/iframe_api";
    var firstScriptTag = document.getElementsByTagName('script')[0];
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

    var url = "http://www.youtube.com/embed/" + videoIds[0] + "?enablejsapi=1&autoplay=1"
    $('#yt-video').attr('src', url);

    function onYouTubeIframeAPIReady() {
      player = new YT.Player('#yt-video', {
        events: {
          'onReady': onPlayerReady
        }
      });
    }

    function onPlayerReady(event) {
      event.target.playVideo();
    }
  }

  $('#yt-close').on('click', function () {
    $('.video-container').slideToggle();
    $('#yt-video').attr('src', '').css('height', 28);
  });

  $('#yt-video-expand').on('click', function () {
    utils.toggleHeight($('#yt-video'), 28, 200)
  })
});

