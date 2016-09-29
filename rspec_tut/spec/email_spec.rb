require 'email'

describe EmailVerificationJob do
  describe "#perform" do
    it "finds the email by id" do
      allow(UserMailer).to receive(:send_verification_email)
      expect(Email).to receive(:find).with(12)

      EmailVerificationJob.new.perform(12)
    end

    it "sends the verification email" do
      email = double
      allow(Email).to receive(:find) { email }

      expect(UserMailer).to receive(:send_verification_email).with(email)

      EmailVerificationJob.new.perform(12)
    end
  end
end