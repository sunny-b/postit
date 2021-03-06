module ApplicationHelper
  def fix_url(url)
    url.match(/https?:\/\//) ? url : "http://#{url}"
  end

  def display_datetime(dt)
    if logged_in? && !current_user.time_zone.blank?
      dt = dt.in_time_zone(user_time_zone)
    end
    
    dt.strftime("%m/%d/%y %I:%M%p %Z")
  end

  def user_time_zone
    ActiveSupport::TimeZone[current_user.time_zone]
  end
end
