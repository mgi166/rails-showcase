class RepositoryDecorator < ApplicationDecorator
  delegate_all

  # NOTE: [sugi/blinky](https://github.com/sugi/blinky)
  def thumbnail
    case
    when URI.regexp =~ object.html_url
      '/assets/thumbnail_not_found.png'
    else
      "https://blinky.nemui.org/shot/xlarge?#{object.html_url}"
    end
  end
end
