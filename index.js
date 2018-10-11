var map = L.map('mapid').setView([51.505, -0.09], 13);

L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
  maxZoom: 18,
  attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
}).addTo(map);

function loadData(data) {
  const group = L.featureGroup();
  group.addTo(map);

  data.points.forEach(({lat, lon}) => {
    L.marker([lat, lon]).addTo(group)
  });

  const bounds = data.bounds;
  L.rectangle([
    [bounds[0], bounds[2]],
    [bounds[1], bounds[3]],
  ]).addTo(map);

  map.fitBounds(group.getBounds().pad(0.5));
}
