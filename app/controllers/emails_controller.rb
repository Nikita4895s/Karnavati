class EmailsController < ApplicationController
  def new
  	@url = params[:url]
  end

  def send_email
  	data = { pdf_url: params[:pdf_url], 
			   to_email: params[:to_email], 
			   cc_emails: params[:cc_emails], 
			   subject: params[:subject], 
			   content: params[:content]
			  }
  	UserMailer.send_email(data).deliver_now
  end
end
