SC.initialize({
  client_id: "27f71ecb6fb79ea3160d95d05b246693"
});

// Display SC button if there are enough tracks

$('body').on('click', '.sc-trigger', function () {
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
