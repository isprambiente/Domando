class UserMailer < ApplicationMailer
  def propose_email
    @author    = params[:author]
    @propose = params[:propose]
    mail(to: email_address_with_name(@author.email, @author.label), subject: "[Faq] Inviata nuova proposta")
  end
end
