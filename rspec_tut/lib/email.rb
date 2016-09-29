class EmailVerificationJob
  def perform(email_id)
    email = Email.find(email_id) 
    UserMailer.send_verification_email(email)
  end
end

class UserMailer
  def self.send_verification_email(id)
  end
end

class Email
end