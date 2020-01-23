class RentalsController < ApplicationController
  before_action :authorize_user!, only: %i[confirm]
  before_action :set_rental!, only: %i[confirm show closure_review finalize
                                       start review]

  def index
    @rentals = Rental.where(subsidiary: current_subsidiary)
  end

  def new
    @rental = Rental.new
    @clients = Client.all
    @categories = Category.all
  end

  def create
    @rental = Rental.new(rental_params)
    subsidiary = current_subsidiary
    @rental.subsidiary = subsidiary
    @rental.status = :scheduled
    return redirect_to rental_path(@rental.id) if @rental.save

    @clients = Client.all
    @categories = Category.all
    render :new
  end

  def confirm
    return redirect_to @rental unless @rental.in_review?

    if @car = Car.find_by(id: params[:car_id])
      build_car(@car.id, @rental.id, params[:addon_ids])
      render :confirm
    else
      flash[:danger] = 'Carro deve ser selecionado'
      @cars = @rental.available_cars
      @addons = Addon.joins(:addon_items)
                     .where(addon_items: { status: :available }).group(:id)
      render :review
    end
  end

  def show; end

  def search
    @rental = Rental.find_by(reservation_code: params[:q])
    return redirect_to @rental if @rental

    @rentals = Rental.where(subsidiary: current_subsidiary)
    flash[:danger] = 'Nenhuma locação encontrada'
    render :index
  end

  def review
    if @rental.scheduled?
      @rental.in_review!
      @cars = @rental.available_cars.where(subsidiary: current_subsidiary)
      @addons = Addon.joins(:addon_items)
                     .where(addon_items: { status: :available }).group(:id)
    elsif @rental.ongoing?
      redirect_to closure_review_rental_path(@rental)
    end
  end

  def closure_review
    redirect_to @rental unless @rental.ongoing?
  end

  def start
    return redirect_to @rental unless @rental.in_review?

    @rental.ongoing!
    redirect_to @rental
  end

  private

  def build_car(car_id, rental_id, addons_ids = [])
    car = Car.find_by(id: car_id)
    car.unavailable!
    rental = Rental.find_by(id: rental_id)
    rental.rental_items.create(rentable: car, daily_rate:
                               car.category.daily_rate +
                               car.category.third_party_insurance +
                               car.category.car_insurance)
    if addons = Addon.where(id: addons_ids)
      addon_items = addons.map(&:first_available_item)
      addon_items.each do |addon_item|
        addon_item.unavailable!
        rental.rental_items.create(rentable: addon_item,
                                   daily_rate: addon_item
                                   .current_price(current_subsidiary))
      end
    end
  end

  def rental_params
    params.require(:rental).permit(:category_id, :client_id, :start_date,
                                   :end_date,
                                   rental_items_attributes: [:car_id])
  end

  def set_rental!
    @rental = Rental.find(params[:id])
  end

  def authorize_user!
    @rental = Rental.find(params[:id])
    unless current_user.admin? || @rental.subsidiary == current_subsidiary
      redirect_to @rental
    end
  end
end
