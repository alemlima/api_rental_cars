class CarsController < ApplicationController
  before_action :authorize_user!, only: %i[edit update show]

  def index
    @cars = Car.where(subsidiary: current_subsidiary)
  end

  def new
    @car = Car.new
    @car_models = CarModel.all
  end

  def create
    @car = Car.new(car_params)
    @car.subsidiary = current_subsidiary
    return redirect_to @car if @car.save

    @car_models = CarModel.all
    render :new
  end

  def show
    @car = Car.find(params[:id])
  end

  def edit
    @car = Car.find(params[:id])
    @car_models = CarModel.all
  end

  def update
    @car = Car.find(params[:id])
    return redirect_to @car if @car.update(car_params)

    @car_models = CarModel.all
    render :edit
  end

  private

  def car_params
    params.require(:car).permit(%i[car_model_id car_km color license_plate])
  end

  def authorize_user!
    unless Car.find(params[:id]).subsidiary == current_subsidiary
      redirect_to cars_path
    end
  end
end
