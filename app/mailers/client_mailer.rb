class ClientMailer < ApplicationMailer
  default from: 'registration@rentalcars.com.br'

  def welcome_email(client_id)
    @client = Client.find(client_id)
    mail(to: @client.email, subject: "Olá #{@client.name}, bem vindo a Rental Cars!")
  end
end
