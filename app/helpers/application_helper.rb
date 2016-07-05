module ApplicationHelper
  def logged_in
    session[:user_id] && User.find_by_id(session[:user_id])
  end

  def current_user
    session[:user_id] && User.find_by_id(session[:user_id])
  end

  def adjust_time_and_format(time, format = :long)
    time.in_time_zone('EST').to_formatted_s(format)
  end
end
