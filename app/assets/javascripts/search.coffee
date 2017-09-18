# Toggle between the search form and the search input view.
$(document).on "click", ".toggle-search-form", (event) ->
  $('#searchForm').toggle()
  $('#searchInput').toggle()

# Toggle between the results grid and the results map.
# Need to trigger a resize event on the map to ensure it renders properly.
$(document).on "click", ".toggle-results", (event) ->
  $('#mapView').toggle()
  $('#eventsGrid').toggle()
  $('#showMapView').toggle()
  $('#showListView').toggle()
  google.maps.event.trigger(map,'resize');
  map.fitBounds(mapBounds);

# set up variables
icons = {}
map = null
countryRestrict = {'country': 'us'}
autocomplete = null
mapBounds = null
selectedMarker = null
markers = []
iconBase = 'https://maps.google.com/mapfiles/kml/';

# Google maps setup

initMap = ->
  map = new google.maps.Map $('#map').get(0)
  urlParams = new URLSearchParams(window.location.search)
  fBLat = parseFloat(urlParams.get('f_b_lat'))
  fFLat = parseFloat(urlParams.get('f_f_lat'))
  bBLng = parseFloat(urlParams.get('b_b_lng'))
  bFLng = parseFloat(urlParams.get('b_f_lng'))

  boundA = new google.maps.LatLng(fBLat, bBLng)
  boundB = new google.maps.LatLng(fFLat, bFLng)

  currentBounds = new google.maps.LatLngBounds(boundA, boundB)

  mapBounds.extend(boundA)
  mapBounds.extend(boundB)

  lng = parseFloat(urlParams.get('lng'))
  lat_field = $('#lat')

  map.fitBounds mapBounds

addMarkers = ->
  mapMarkerStore = $('#mapMarkerStore').get(0)
  events = JSON.parse(mapMarkerStore.dataset.json)

  for i in [0...events.length]
    e = events[i];
    if e.venue
      markerParams = {
        position: { lat: e.venue.latitude, lng: e.venue.longitude },
        map: map,
        title: e.name,
        icon: icons.default.icon,
        json: e
      }

      marker = new google.maps.Marker markerParams

      markers.push(marker)

      marker.addListener 'click', ->
        selectMarker(this)

  selectMarker markers[0]

selectMarker = (marker) ->
  id = "event-list-" + marker.json.id
  $('.event-list').hide()
  $('#' + id).show()
  if selectedMarker
    selectedMarker.setIcon(icons.default.icon)

  marker.setIcon(icons.selected.icon)
  map.panTo(marker.getPosition())
  selectedMarker = marker

# Runs when the DOM is ready.
$ ->
  $('#searchForm').toggle()
  $('#mapView').toggle()
  $('#showListView').toggle()

  # Initialize map variables and icons
  mapBounds = new google.maps.LatLngBounds()
  selectedMarker = new google.maps.Marker()

  iconBase = 'https://maps.google.com/mapfiles/kml/';
  icons = {
    default: {
      icon: {
        url: iconBase + 'paddle/orange-blank.png',
        size: new google.maps.Size(71, 71),
        origin: new google.maps.Point(0, 0),
        anchor: new google.maps.Point(17, 34),
        scaledSize: new google.maps.Size(36, 36)
      }
    },
    selected: {
      icon: {
        url: iconBase + 'paddle/red-circle.png',
        size: new google.maps.Size(71, 71),
        origin: new google.maps.Point(0, 0),
        anchor: new google.maps.Point(17, 34),
        scaledSize: new google.maps.Size(42, 42)
      }
    }
  }

  initMap()
  addMarkers()
  initAutocomplete()
