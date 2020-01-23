class CorporateClient < Client
  validates :email, presence: true
  validates :trade_name, presence: true
  validates :cnpj, presence: true

  def name
    trade_name
  end

  def cpf
    cnpj
  end

  def client_description
    "#{name} | CNPJ: #{cpf} | #{email}"
  end
end
