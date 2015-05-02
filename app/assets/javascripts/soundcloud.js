SC.initialize({
  client_id: "27f71ecb6fb79ea3160d95d05b246693"
});

// Display SC button if there are enough tracks

$('.sc-trigger').each(function (i, el) {
  var trigger = $(this);
  var query = trigger.data('query');

  SC.get('/tracks', {q: query, limit: 5}, function (tracks) {
    if (tracks.length === 5) {
      trigger.show();
      trigger.data('scUrl', tracks[0].permalink_url)
    }
  });
});

$('.sc-trigger').on('click', function () {
  utils.endYoutubePlayer();

  var trackUrl = $(this).data('scUrl');

  SC.oEmbed(trackUrl, {
      auto_play: true,
      maxheight: 166
    },
    function (oEmbed) {
      $('#sc-widget').append(oEmbed.html);
      $('#sc-player').slideToggle();
    });
});

$('#sc-close').on('click', function () {
  utils.endSoundcloudPlayer();
});
