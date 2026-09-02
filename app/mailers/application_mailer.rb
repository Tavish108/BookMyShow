class ApplicationMailer < ActionMailer::Base
  default from: "abc.def@ghi.com"
  layout "mailer"
end
