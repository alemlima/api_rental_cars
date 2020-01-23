class User < ApplicationRecord
  belongs_to :subsidiary, optional: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :registerable
  # and :omniauthable
  enum role: { user: 0, admin: 1 }
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable
end
