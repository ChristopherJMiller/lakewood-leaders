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
      @announcement = announcement
      headers['List-Unsubscribe'] = "<https://leaders.lrhsclubs.com/unsubscribe/>"
      User.connection.select_values(User.select("parent_email").where("parent_verified": true).where.not(parent_email: nil).to_sql) do |parent|
        mail to: parent, subject: "Lakewood Leaders: #{@announcement.title}"
      end
      User.connection.select_values(User.select("email").where(verified: true).to_sql).each do |user|
        mail to: user, subject: "Lakewood Leaders: #{@announcement.title}"
      end
    end
end
