require 'rails_helper'
  RSpec.describe ClientMailer do
    describe "#welcome_email" do
      it 'should send a email with client email' do
        client = create(:individual_client, email: 'test@email.com')
        mail = ClientMailer.welcome_email(client.id)

        expect(mail.to).to include(client.email)

      end
      
      it 'should send from correct email' do
        client = create(:individual_client)
        mail = ClientMailer.welcome_email(client.id)

        expect(mail.from).to eq('registration@rentalcars.com.br')

      end

      it 'should have the correct subject' do
        client = create(:individual_client)
        mail = ClientMailer.welcome_email(client.id)

        expect(mail.subject).to eq("Olá #{client.name}, bem vindo a Rental Cars!" )
      end

      it 'should have the correct message' do
        client = create(:individual_client)
        mail = ClientMailer.welcome_email(client.id)

        expect(mail.body).to include("Caro #{client.name}, obrigado por ser nosso cliente!")

      end

    end
  end