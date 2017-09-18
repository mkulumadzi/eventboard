@initAutocomplete = ->
  @autocomplete = new google.maps.places.Autocomplete $("#autocomplete").get(0), { types: ['(cities)'] }
  autocomplete.addListener 'place_changed', placeSelected

@placeSelected = ->
  place = autocomplete.getPlace()

  viewport = place.geometry.viewport
  center_lat = (viewport.f.b + viewport.f.f) / 2
  center_lng = (viewport.b.b + viewport.b.f) / 2
  $('#lat').get(0).value = center_lat;
  $('#lng').get(0).value = center_lng;

  $('#f-b-lat').get(0).value = viewport.f.b;
  $('#f-f-lat').get(0).value = viewport.f.f;
  $('#b-b-lng').get(0).value = viewport.b.b;
  $('#b-f-lng').get(0).value = viewport.b.f;
