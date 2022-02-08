class FaqMailer < ApplicationMailer
  def propose_email
    @user    = params[:user]
    @author  = params[:author]
    @propose = params[:propose]
    mail(to: email_address_with_name(@user.email, @user.label), subject: "[Faq] Inviata nuova proposta")
  end
end
