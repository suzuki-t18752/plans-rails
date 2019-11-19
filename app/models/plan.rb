class Plan < ApplicationRecord
  belongs_to :user
  
  validates :title, presence: true,    length: { maximum: 100 }
  
  if blank?
    validates :startday, length: { in: 8..12 }, numericality: { only_integer: true}
  end
  
  if blank?
    validates :endday, length: { in: 8..12}, numericality: { only_integer: true}
  end
  
  if blank?
    validates :content, length: { in: 1..200 }
  end
  
  if blank?
    validates :diary, length: { in: 1..200 }
  end
  
  has_many :keeps
  has_many :keeps, dependent: :destroy
  
  
  def kept_by?(user)
    keeps.where(user_id: user.id).exists?
  end
  
  
  scope :search, -> (search_params) do
    return if search_params.blank?

    title_like(search_params[:title])
      .startday_from(search_params[:startday_from])
      .startday_to(search_params[:startday_to])
      .endday_from(search_params[:endday_from])
      .endday_to(search_params[:endday_to])
  end
  scope :title_like, -> (title) { where('title LIKE ?', "%#{title}%") if title.present? }
  scope :startday_from, -> (from) { where('? <= startday', from) if from.present? }
  scope :startday_to, -> (to) { where('startday <= ?', to) if to.present? }
  scope :endday_from, -> (from) { where('? <= endday', from) if from.present? }
  scope :endday_to, -> (to) { where('endday <= ?', to) if to.present? }
end
