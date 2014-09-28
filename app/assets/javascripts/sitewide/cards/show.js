var CardsController = Paloma.controller('Cards');

CardsController.prototype.show = function() {

  // call the map
  load_google_map.loadScript('card_show.initialize', 
        [this.params['lat'], this.params['lng']], true);

};

var card_show = {
  initialize: function(lat, lng) {
    var latlng = new google.maps.LatLng(lat, lng);
    var mapOptions = {
      center: latlng,
      zoom: 15,
      mapTypeId: google.maps.MapTypeId.PLAN
    };
    var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
    geocoder = new google.maps.Geocoder();
    marker = new google.maps.Marker({position: latlng,map: map});
  }
};