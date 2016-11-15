# = Applicaiton mailer
# Base action mailer for use in project
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
