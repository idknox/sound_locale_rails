window.soundcloud = {
  init: function () {
    SC.initialize({
      client_id: "27f71ecb6fb79ea3160d95d05b246693"
    });
    console.log('SOUNDCLOUD PLAYER LOADED')
  },

  startPlayer: function (trackUrl) {
    youtube.endPlayer();
    this.endPlayer();

    SC.oEmbed(trackUrl, {
        auto_play: true,
        maxheight: 166
      },
      function (oEmbed) {
        $('#sc-widget').append(oEmbed.html);
        $('#sc-player').slideToggle();
      });
  },

  endPlayer: function () {
    if (!utils.isHidden($('#sc-player'))) {
      $('#sc-player').slideToggle();
      $('#sc-widget').empty();
    }
  }
};

