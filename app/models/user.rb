class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable

  has_many :teaching_materials, dependent: :destroy
  has_many :diseases, dependent: :destroy
  has_many :tags, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }
end
