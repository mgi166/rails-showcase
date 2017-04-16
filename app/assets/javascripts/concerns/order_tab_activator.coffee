$(document).on('ready turbolinks:load', () ->
  $(".nav-tabs a").on('click', (e) ->
    e.preventDefault();
    path = $(e.target).attr("href")
    window.location.href = path if path?
  );

  # NOTE: Activate tab from url paramter
  (->
    url = new URL(window.location.href)
    target = url.searchParams.get("order")
    $("a.nav-link.#{target}").addClass("active")
  )()
)
