window.eventUi = {
  displayGrid: function () {
    $('.events-list, .toggle-all').hide();
    $('.grid-container, .grid-instructions').show();
    localStorage['eventView'] = 'grid';
  },

  displayList: function () {
    $('.grid-container, .grid-instructions').hide();
    $('.events-list, .toggle-all').show();
    localStorage['eventView'] = 'list';
  },

  displayAll: function () {
    $('.date-content, #close-all').show();
    $('#expand-all').hide();
    this.stickyDate = true;
  },

  displayFiltered: function () {
    eventUi.displayList();
    $('.date-content').show();
    $('.toggle-all').hide();
    $('.expand').empty().append('\u00a0');
    this.stickyDate = false;
  },

  closeAll: function () {
    $('.date-content, #close-all').hide();
    $('#expand-all').show();
    this.stickyDate = false;
  },

  loadTodayEvents: function () {
    var today = $('.date-header').first().siblings('.date-content');
    var timestamp = new Date();
    var date = new Date(timestamp.getFullYear(), timestamp.getMonth(), timestamp.getDate());
    $.get('/events/date/' + date).success(function (events) {
      eventUi.insertEvents(today, events);
      today.slideToggle();
    });
  },
  expandAndFillDate: function (header) {
    var content = header.siblings('.date-content');
    var headerDate = header.data('date');
    var menuHeight = $('#nav-custom').height();

    var timestamp = new Date(headerDate);
    var date = new Date(timestamp.getFullYear(), timestamp.getMonth(), timestamp.getDate());

    $.get('/events/date/' + date, {}, function (events) {
      eventUi.insertEvents(content, events);

      $('html,body').animate({
        scrollTop: header.offset().top - menuHeight
      }, 500);

      content.slideToggle();

    });
  },

  insertEvents: function (container, events) {
    $.each(events, function (i, event) {

      var opener = event.opener || '';

      var event = '<div class="event clear"><div class="col-xs-12 col-md-5 title">' +
        '<div class="headliner">' + event.headliner + '</div>' +
        '<div class="opener">' + opener + '</div></div><div class="col-xs-12 ' +
        'col-md-5 info">' + 'Event time' + ' @ <a href="/venues/' + event.venue.id +
        '" class="body-link">' + event.venue.name + '</a><div class="price">' +
        event.price + '</div></div><div class="col-xs-12 col-md-2 links">' +
        '<div class="row"><div class="col-xs-3"><a class="tickets-trigger" href="' + event.tickets + '"><i class="fa fa-ticket ' +
        '"></i></a></div><div class="col-xs-3">' +
        '<i class="fa fa-map-marker map-trigger" data-venue-id="' + event.venue.id +
        '"></i></div><div class="col-xs-3"><i class="fa fa-youtube-play yt-trigger"' +
        'data-query="' + event.headliner + '"></i></div><div class="col-xs-3">' +
        '<i class="fa fa-soundcloud sc-trigger" data-query="' + event.headliner +
        '"></i></div></div></div></div></div>';

      eventUi.showScButton(container);
      container.append(event);
    })
  },

  showScButton: function (date) {
    date.find('.sc-trigger').each(function (i, el) {
      var trigger = $(this);
      var query = trigger.data('query');
      var storedDate = localStorage.getItem(query);

      if (!storedDate) {

        SC.get('/users', {q: query, limit: 1}, function (users) {

          if (users.length > 0) {
            var userId = users[0].id;

            SC.get('/users/' + userId + '/tracks', {limit: 1}, function (tracks) {
              if (tracks.length > 0) {
                localStorage[query] = tracks[0].permalink_url;
                trigger.show();
                trigger.data('scUrl', localStorage[query]);
              }
            })
          } else {
            localStorage[query] = 'false';
          }
        });
      } else if (storedDate && storedDate !== 'false') {
        trigger.show();
        trigger.data('scUrl', storedDate)
      }
    });
  },

  scrollToMonth: function (month) {
    $('html,body').animate({
      scrollTop: $('#' + month).offset().top - $('#nav-custom').height()
    }, 500);
  }
};