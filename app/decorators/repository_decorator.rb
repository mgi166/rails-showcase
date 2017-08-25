class RepositoryDecorator < ApplicationDecorator
  delegate_all

  # NOTE: [sugi/blinky](https://github.com/sugi/blinky)
  def thumbnail
    "https://blinky.nemui.org/shot/xlarge?#{object.html_url}"
  end
end
