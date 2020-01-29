require 'rails_helper'
  describe 'Car model management' do
    context 'get' do
      it 'should get fipe price from FIPE API' do
        car_model = create(:car_model)
        
        http_response = double("response", body: { 'preco': 'R$ 10.000,00' }.to_json, code: 200)
        double_get = double("get")

        allow(Net::HTTP::Get).to receive(:new).with('/api/1/carros/veiculo/21/4828/2014-1.json')
        .and_return(double_get)

        allow_any_instance_of(Net::HTTP).to receive(:request).with(double_get).and_return(http_response)

        result = car_model.fipe_price()

        expect(result).to eq 'R$ 10.000,00'

      end
    end
  end
