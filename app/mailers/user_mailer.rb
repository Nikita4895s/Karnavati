class UserMailer < ApplicationMailer
  default from: 'karnavati.inst@gmail.com'
  def send_email(data)
	attachments['products.pdf'] = File.read(data[:pdf_url])
    @url  = 'http://example.com/login'
    mail(to: data[:to_email], subject: data[:subject])
  end
end
