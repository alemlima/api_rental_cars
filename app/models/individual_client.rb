class IndividualClient < Client
  validates :name, presence: true
  validates :email, presence: true
  validates :cpf, presence: true

  def client_description
    "#{name} | CPF: #{cpf} | #{email}"
  end
end
