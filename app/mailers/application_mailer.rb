class ApplicationMailer < ActionMailer::Base
  default from: Settings.bug.email
  layout 'mailer'
end
