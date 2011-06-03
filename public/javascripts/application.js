// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {
  $("#event_artist_tokens").tokenInput("/artists.json", {
    crossDomain: false,
	preventDuplicates: true,
	prePopulate: $("#event_artist_tokens").data("pre"),
  });
});
$(function() {
  $("#event_venue_token").tokenInput("/venues.json", {
    crossDomain: false,
	preventDuplicates: true,
	prePopulate: $("#event_venue_token").data("pre"),
	tokenLimit: 1,
	minChars: 3
  });
});