module EmailHelper
  require 'net/smtp'

  @@EMAIL_ACCOUNT        = 'info@solutionadn.com'
  @@PASSWORD             = 'solutionadn'
  @@DOMAIN               = 'solutionadn.com'

  @@REGISTRATION_CONTENT = IO.read('./app/assets/emails/registration_email.html')
  @@ACTIVATION_CONTENT = IO.read('./app/assets/emails/activation_email.html')
  @@NEWMAIL_CONTENT = IO.read('./app/assets/emails/newmail_email.html')

  def send_email(email, msg)
    smtp = Net::SMTP.new 'smtp.gmail.com', 587
    smtp.enable_starttls
    smtp.start(@@DOMAIN, @@EMAIL_ACCOUNT,
               @@PASSWORD, :login) do
      smtp.send_message msg,
                        'noreply@solutionadn.com',
                        email
    end
  end
end
