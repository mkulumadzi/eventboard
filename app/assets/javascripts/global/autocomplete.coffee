@initAutocomplete = ->
  @autocomplete = new google.maps.places.Autocomplete $("#autocomplete").get(0)
  autocomplete.addListener 'place_changed', placeSelected

@placeSelected = ->
  place = autocomplete.getPlace()
  handlePlace place

handlePlace = (place) ->
  viewport = place.geometry.viewport

  $('#lat').get(0).value = place.geometry.location.lat()
  $('#lng').get(0).value = place.geometry.location.lng()

  center = new google.maps.LatLng(place.geometry.location.lat(), place.geometry.location.lng())
  corner = new google.maps.LatLng(viewport.f.b, viewport.b.b)

  radiusMeters = google.maps.geometry.spherical.computeDistanceBetween(center, corner)
  radiusMiles = Math.floor(radiusMeters * 0.00062)

  if radiusMiles >= 1
    radius = radiusMiles
  else
    radius = 1

  $('#radius').get(0).value = radius

@getCurrentLocation = ->
  $("#autocomplete").get(0).placeholder = "Loading..."

  if navigator.geolocation
    console.log("We have a navigator")
    navigator.geolocation.getCurrentPosition (position) ->
      pos = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      }
      location = { 'location': pos }

      geocoder = new google.maps.Geocoder
      geocoder.geocode location, (results, status) ->
        if status == 'OK' && results[0]
          place = results[0]
          handlePlace place
          autocompleteTextBox = $("#autocomplete").get(0)
          address1 = place.formatted_address.split(",")[0]
          autocompleteTextBox.value = address1
        else
          $("#autocomplete").get(0).placeholder = "Your location"
