class UserMailer < ActionMailer::Base
  default from: "support@dayable.com"

  def welcome_email(user)
    @user = user
    @url = "http://dayable.com/signin"
    mail(:to => user.email, :subject => 'Welcome to dayable!')
  end
end
