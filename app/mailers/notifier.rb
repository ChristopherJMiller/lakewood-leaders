# = Notifier
# Application Mail for sending emails to users
class Notifier < ApplicationMailer
  default from: 'lakewoodleaders@mctherealm.net'

  def verify_email(user)
    @user = user
    mail to: user.email, subject: 'Lakewood Leaders Email Verification'
  end

  def verify_parent_email(user)
    @user = user
    mail to: user.parent_email, subject: 'Lakewood Leaders Parent Email Verification'
  end

  def announce(announcement)
    User.where(parent_verified: true).where.not(parent_email: nil).each do |user|
      mail_announcement(announcement, user.parent_email).deliver
    end
    count = User.where(verified: true).count
    i = 1
    User.where(verified: true).each do |user|
      if i != count
        mail_announcement(announcement, user.email).deliver
      else
        mail_announcement(announcement, user.email)
      end
      i += 1
    end
  end

  def mail_announcement(announcement, email)
    @announcement = announcement
    headers['List-Unsubscribe'] = '<https://leaders.lrhsclubs.com/unsubscribe/>'
    mail to: email, subject: "Lakewood Leaders: #{@announcement.title}"
  end
end
