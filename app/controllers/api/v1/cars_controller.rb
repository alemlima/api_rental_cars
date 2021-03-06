class Api::V1::CarsController < Api::V1::ApiController
  def show
    @car = Car.find(params[:id])
    @photo = url_for(@car.photo)
    render json: {car: @car, photo: @photo}
  end
  
  def index
    @cars = Car.all
    unless @cars.empty?
      render json: @cars
    else
      render json: {message: 'No records found'}, status: :not_found
    end
  end

  def create
    @car = Car.new(car_params)
    
    if @car.valid?
      #photo_path = params.permit(:photo)["photo"]
      #@car.photo.attach(io: File.open(photo_path), filename: photo_path.split('/')[-1])
      @car.save!
      render json: {message: 'Created successfully'}, status: :created 
    else
      render json: {Validation_failure: @car.errors.full_messages}, status: :precondition_failed
    end
  end
  
  def update 
    @car = Car.find(params[:id])
    @car.update(car_params)
    
      render json: {message: 'Updated successfully'}, status: :ok
  end

  def destroy
    @car = Car.find(params[:id])
    @car.delete
    render json: {message: 'Deleted successfully'}, status: :ok
  end

  private

  def car_params
    params.permit(:car_km, :license_plate, :color,
                                :subsidiary_id, :car_model_id)
  end

  
end