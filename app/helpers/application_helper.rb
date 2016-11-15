# = Application Helper
module ApplicationHelper
  def logged_in
    session[:user_id] && User.find_by(id: session[:user_id])
  end

  def current_user
    session[:user_id] && User.find_by(id: session[:user_id])
  end

  def format_time(time)
    time.strftime('%b %d, %Y %I:%M %p')
  end

  def ranks
    if User.find_by(id: session[:user_id]).rank == 3
      ['Non-Member', 'Member', 'Officer', 'Advisor']
    else
      ['Non-Member', 'Member']
    end
  end

  def rank_title(rank)
    titles = ['Non-Member', 'Member', 'Officer', 'Advisor']
    titles[rank]
  end
end
