# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on('ready turbolinks:load', () ->
  $("td.rails-showcase.clickable-row").on("click", (e) ->
    path = $(e.target).find("a").attr("href")
    window.location.href = path
  )
)
