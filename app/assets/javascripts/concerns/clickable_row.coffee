$(document).on('ready turbolinks:load', () ->
  $("td.rails-showcase.clickable-row").on("click", (e) ->
    path = $(e.target).find("a").attr("href")
    window.location.href = path
  )
)
