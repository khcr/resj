/*
*   Set view of Leaflet map based on screen size
*/
if ($(window).width() < 626) {
        var map = L.mapbox.map('map', 'nkcr.gjhi4d72').setView([latCenter, lngCenter], 8);
} else {
        var map = L.mapbox.map('map', 'nkcr.gjhi4d72', {fullscreenControl: true}).setView([latCenter, lngCenter], 9);
}
/*
*   create markercluster
*/
var markers = new L.MarkerClusterGroup({
  maxClusterRadius: 30,
});
/*
*   Add points
*/
for (var i = 0; i < addressPoints.length; i++) {
  var a = addressPoints[i];
  var title = a[2];
  var marker = L.marker(new L.LatLng(a[0], a[1]), options={
  	icon: L.icon({
      iconUrl: icon+a[3]+".png",
      iconRetinaUrl: 'my-icon@2x.png',
      iconSize: [25, 41],
      iconAnchor: [12, 41],
      popupAnchor: [0, -30],
      shadowUrl: shadow,
      shadowRetinaUrl: 'my-icon-shadow@2x.png',
      shadowSize: [41, 41],
      shadowAnchor: [12, 41]
    }),
    title: title,
    riseOnHover: true,
    id: a[4],
  });
  marker.bindPopup(title);
  markers.addLayer(marker);
}
/*
*   Custom map
*/
markers.on('mouseover', function(e) {
    e.layer.openPopup();
});
markers.on('click', function(e) {
    e.layer.openPopup();
});
map.scrollWheelZoom.disable();
map.addControl(L.mapbox.shareControl())
map.addLayer(markers);