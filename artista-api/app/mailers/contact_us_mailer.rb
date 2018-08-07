class ContactUsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_us_mailer.contact_us.subject
  #
  def contact_us(contact_us_params)
    @contact_us_params = contact_us_params

    mail to: "artifish.info@gmail.com", subject: "Contact Us from Artifish MVP"
  end
end
