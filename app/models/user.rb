class User < ApplicationRecord
  has_many :plans
  has_many :plans, dependent: :destroy
  
  validates :name, presence: true, length: { maximum: 25 }
  has_secure_password

  has_many :keeps
  has_many :keeps, dependent: :destroy
  
  def self.search(search)
    if search
      User.where(['name LIKE ?', "%#{search}%"])
    else
      User.all
    end
  end
end
