class MyM < ActionMailer::Base
  default :from => "no-reply@executter.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.my_m.forgot_password.subject
  #
  def forgot_password(user, token)
    @user, @token = user, token
    mail  :from => "forgot-password@executter.com",
          :to => user.email,
          :subject => "Sua Senha no Executter"
  end

  def notification(pun)
    mail_to = My.production? ? pun.user.email : 'test@oficina7.com'
    @pun = pun
    mail  :from => "#{pun.reason_why}@executter.com",
          :to => mail_to,
          :subject => "#{pun.user_from.fn_} #{pun.reason}"
    
  end
end
