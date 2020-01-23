# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rental, type: :model do
  context '#generate_random_token' do
    it 'should generate a random reservation code' do
      rental = build(:rental)

      expect(rental.send(:generate_random_token)).to match(/[0-9A-Z]{6}/)
    end
  end

  context '#generate_reservation_code' do
    it 'should generate a random reservation code on create' do
      subsidiary = create(:subsidiary, name: 'Almeida Motors')
      category = create(:category, name: 'A', daily_rate: 10, car_insurance: 20,
                                   third_party_insurance: 20)
      customer = create(:individual_client, name: 'Claudionor',
                                            cpf: '318.421.176-43',
                                            email: 'cro@email.com')
      car_model = create(:car_model, name: 'Sedan', category: category)
      create(:car, car_model: car_model, subsidiary: subsidiary)
      rental = build(:rental, category: category, subsidiary: subsidiary,
                              client: customer, start_date: '3000-01-01',
                              end_date: '3000-01-03')
      rental.save!

      expect(rental).to be_persisted
      expect(rental.reservation_code).to match(/[0-9A-Z]{6}/)
    end

    it 'and code must be unique' do
      subsidiary = create(:subsidiary, name: 'Almeida Motors')
      category = create(:category, name: 'A', daily_rate: 10, car_insurance: 20,
                                   third_party_insurance: 20)
      customer = create(:individual_client, name: 'Claudionor',
                                            cpf: '318.421.176-43',
                                            email: 'cro@email.com')
      car_model = create(:car_model, name: 'Sedan', category: category)
      create(:car, car_model: car_model, subsidiary: subsidiary)
      create(:car, car_model: car_model, subsidiary: subsidiary)

      create(:rental, :without_callbacks, start_date: '3000-01-01',
                                          end_date: '3000-01-03',
                                          category: category,
                                          subsidiary: subsidiary,
                                          client: customer,
                                          reservation_code: 'ACB123')
      rental = build(:rental, category: category, subsidiary: subsidiary,
                              client: customer, start_date: '3000-01-01',
                              end_date: '3000-01-03')
      allow(rental).to receive(:generate_random_token)
        .and_return('ACB123', 'HDE123')

      rental.save!

      expect(rental).to be_persisted
      expect(rental.reservation_code).not_to eq 'ACB123'
      expect(rental.reservation_code).to match(/[0-9A-Z]{6}/)
    end
  end
end
