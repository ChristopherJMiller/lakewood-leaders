class Notifier < ApplicationMailer
    default from: 'lakewoodleaders@mctherealm.net'

    def verify_email(user)
      @user = user
      mail to: user.email, subject: 'Lakewood Leaders Email Verification'
    end

    def announce(announcement)
      @announcement = announcement
      mail to: User.connection.select_values(User.select("email").to_sql), subject: "Lakewood Leaders: #{@announcement.title}"
    end
end
