module ApplicationHelper
  def fix_url(url)
    url.match(/https?:\/\//) ? url : "http://#{url}"
  end

  def display_datetime(dt)
    dt.strftime("%m/%d/%y %I:%M%p ETC")
  end
end
