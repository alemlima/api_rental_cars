require 'rails_helper'
  describe "Car management" do
    context 'show' do
        it 'renders a car correctly' do
          car = create(:car)
          car.photo.attach(io: File.open('spec/support/uno.jpeg'), filename: 'uno.jpeg', content_type: 'image/jpeg')

          
          get api_v1_car_path(car)
          
          json = JSON.parse(response.body, symbolize_names: true)
          expect(response).to have_http_status(:ok)
          
          pp json
          expect(json[:car][:car_model_id]).to eq(car.car_model_id)    
          expect(json[:car][:license_plate]).to eq(car.license_plate)    
          expect(json[:car][:car_km]).to eq(car.car_km)    
          expect(json[:car][:color]).to eq(car.color)    
          expect(json[:car][:subsidiary_id]).to eq(car.subsidiary_id)
          expect(json[:photo]).to include('uno.jpeg')
        end
        
        it 'but car was not found' do
          get api_v1_car_path(id: 9999)

          json = JSON.parse(response.body)

          expect(response).to have_http_status(:not_found)
          expect(json['message']).to eq('The record you are looking for was not found on the database')  
        end
     end

    context 'index' do
      it 'render cars correctly' do
        car = create(:car)
        car2 = create(:car, car_km: 20000, license_plate: 'ABC0123')

        get api_v1_cars_path

        json = JSON.parse(response.body, symbolize_names: true)
        
        expect(response).to have_http_status(:ok)
        expect(json[0][:car_model_id]).to eq(car.car_model_id)    
        expect(json[0][:license_plate]).to eq(car.license_plate)    
        expect(json[0][:car_km]).to eq(car.car_km)    
        expect(json[0][:color]).to eq(car.color)    
        expect(json[0][:subsidiary_id]).to eq(car.subsidiary_id)

        expect(json[1][:car_model_id]).to eq(car2.car_model_id)    
        expect(json[1][:license_plate]).to eq(car2.license_plate)
        expect(json[1][:car_km]).to eq(car2.car_km)
        expect(json[1][:color]).to eq(car2.color)
        expect(json[1][:subsidiary_id]).to eq(car2.subsidiary_id)

        expect(json.size).to eq(2)
      end

      it 'does not have any car'do
        
        get api_v1_cars_path
        
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include('No records found')

      end
    end

      context 'create' do
        it 'create a car correctly' do
          subsidiary = create(:subsidiary)
          car_model = create(:car_model)

          expect {
            post api_v1_cars_path, params:{
                                                  car_km: 1000,
                                                  license_plate: 'ABC1234',
                                                  color: 'Azul',
                                                  subsidiary_id: subsidiary.id,
                                                  car_model_id: car_model.id,
                                          }
                 }.to change(Car, :count).by(1)

          expect(response).to have_http_status(:created)
          expect(response.body).to include('Created successfully')

          car = Car.last                                         
          expect(car.car_km).to eq(1000)                                          
          expect(car.license_plate).to eq('ABC1234')                                          
          expect(car.color).to eq('Azul')


        end

        it 'should not create if missing a parameter' do
          post api_v1_cars_path, params: {
                                                  car_km: 1000,
                                                  license_plate: 'ABC1234',
                                                  color: 'Azul'
                                          }

          json = JSON.parse(response.body)
          pp json
          expect(response).to have_http_status(412)
          expect(json['Validation_failure']).to include('Modelo é obrigatório.')
          expect(json['Validation_failure']).to include('Filial é obrigatório(a)')                                  
         end

        it 'should return status 500 if some unexpected error ocurred' do
         
          allow_any_instance_of(Car).to receive(:save!).and_raise(ActiveRecord::ActiveRecordError)

          subsidiary = create(:subsidiary)
          car_model = create(:car_model)

                    
          post api_v1_cars_path, params: {
                                                car_km: 1000,
                                                license_plate: 'ABC1234',
                                                color: 'Azul',
                                                subsidiary_id: subsidiary.id,
                                                car_model_id: car_model.id,    
                                          }
                                         
          json = JSON.parse(response.body)                               
          expect(response).to have_http_status(500)
          expect(json['message']).to eq('An unexpected error ocurred')
                                         
        end

        it 'upload a car photo correctly' do
          subsidiary = create(:subsidiary)
          car_model = create(:car_model)

          
            post api_v1_cars_path, params:{ 
                                                  car_km: 1000,
                                                  license_plate: 'ABC1234',
                                                  color: 'Azul',
                                                  subsidiary_id: subsidiary.id,
                                                  car_model_id: car_model.id,
                                                  photo: Rails.root.join('spec/support/uno.jpeg')
                                          }
          pp response.body                                
          expect(response).to have_http_status(:created)
          expect(response.body).to include('Created successfully')

          car = Car.last
          pp car.photo                                        
          expect(car.car_km).to eq(1000)                                          
          expect(car.license_plate).to eq('ABC1234')                                          
          expect(car.color).to eq('Azul')
          expect(car.photo.attached?).to eq(true)                                

        end
        
       end

      context 'update' do
        it 'should update car successfully' do
          car = create(:car, car_km: 1000, license_plate: 'ABC1234', color: 'Azul')

          put api_v1_car_path(car.id), params: {
                                                      car_km: 20000,
                                                      license_plate: 'DEF5678',
                                                      color: 'Preto',
                                                      photo: Rails.root.join('spec/support/gtr.jpeg')
                                               }

         expect(response).to have_http_status(:ok)
         expect(response.body).to include('Updated successfully')
         car.reload
         
         expect(car.car_km).to eq(20000)
         expect(car.license_plate).to eq('DEF5678')
         expect(car.color).to eq('Preto')

        end

        it 'should not create another car when updating ' do
          car = create(:car, license_plate:'ABC-0987')
          expect{
            patch api_v1_car_path(car), params: {license_plate: 'DEF-1234'}
                }.to change(Car, :count).by(0)
        end

       end

       context 'delete' do
        it 'should delete a car successfully'do
          car = create(:car, license_plate: 'ABC-1234')
          other_car = create(:car, license_plate: 'DEF-5678')

          delete api_v1_car_path(car)

          json = JSON.parse(response.body)
          
          expect(response).to have_http_status(:ok)
          expect(json['message']).to eq('Deleted successfully')
          expect(Car.find_by(license_plate: 'ABC-1234')).to eq(nil)
        end
      end
      
   end
    

  