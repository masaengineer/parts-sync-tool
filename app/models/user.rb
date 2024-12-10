# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           not null
#  profile_picture_url    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  last_name              :string
#  first_name             :string
#
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
