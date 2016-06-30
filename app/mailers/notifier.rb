class Notifier < ApplicationMailer
    default from: 'lakewoodleaders@mctherealm.net'

    def verify_email(user)
      @user = user
      mail to: user.email, subject: 'Lakewood Leaders Email Verification'
    end
end
