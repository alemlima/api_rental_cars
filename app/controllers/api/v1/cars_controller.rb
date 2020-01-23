class Api::V1::CarsController < Api::V1::ApiController
  def show
    @car = Car.find_by(id: params[:id])
    if @car
      render json: @car
    else
      head :not_found
    end
  end
  
  def index
    @cars = Car.all
    render json: @cars
  end

  def create
    @car = Car.new(car_params)
    if @car.valid?
      @car.save
      render json: 'Created successfully', status: :created 
    else
      render json: 'Validation error', status: 412
    end
  end
  
  def update 
    @car = Car.find_by(id: params[:id] )
    @car.update(car_params)
    render json: 'Updated successfully', status: :ok

  end

  private

  def car_params
    params.permit(:car_km, :license_plate, :color,
                                :subsidiary_id, :car_model_id)
  end
end