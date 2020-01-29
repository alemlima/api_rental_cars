class CarModel < ApplicationRecord
  has_one_attached :photo
  belongs_to :manufacture
  belongs_to :fuel_type
  belongs_to :category
  has_many :cars
  validates :name, presence: true
  validates :year, presence: true
  validates :car_options, presence: true

  def fipe_price
    require 'net/http'

    uri = URI('https://fipeapi.appspot.com/')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    req = Net::HTTP::Get.new('/api/1/carros/veiculo/21/4828/2014-1.json')

    result = http.request(req)

    return "Não foi possível obter os dados da tabela FIPE" if result.code == 500
    
    JSON.parse(result.body)["preco"]
  end

end
