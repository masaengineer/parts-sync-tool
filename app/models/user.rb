class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  has_many :orders
  attr_accessor :agreement

  validates :email, presence: true, uniqueness: true
  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :agreement, acceptance: { message: 'You must accept the terms and conditions' }

end
