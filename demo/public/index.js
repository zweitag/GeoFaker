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

  if (data.bounds) {
    const bounds = data.bounds;
    L.rectangle([
      [bounds[0], bounds[2]],
      [bounds[1], bounds[3]],
    ]).addTo(group);
  }

  if (data.geojson) {
    L.geoJSON(data.geojson).addTo(group);
  }

  if (data.circle) {
    L.circle(
      [
        data.circle.center.lat,
        data.circle.center.lon,
      ],
      data.circle.radius * 1000,
    ).addTo(group);

    L.circle(
      [
        data.circle.center.lat,
        data.circle.center.lon,
      ],
      data.circle.radius * 1000 * 2,
      { opacity: 0.4 },
    ).addTo(group);

    L.circle(
      [
        data.circle.center.lat,
        data.circle.center.lon,
      ],
      data.circle.radius * 1000 * 3,
      { opacity: 0.2 },
    ).addTo(group);
  }

  map.fitBounds(group.getBounds().pad(0.5));
}

window.onload = () => {
  // Call the api indicated in the URL along with the query parameters and display the result.
  fetch(`/api${location.pathname}${location.search}`).then(resp => resp.json()).then(loadData);
};
