class Page < ActiveRecord::Base
  # RELATIONS
  belongs_to :user

  # VALIDATIONS
  validates :user,    :presence => true
  validates :title,   :presence => true
  validates :content, :presence => true

  scope :draft,     where(:state => :draft)
  scope :published, where(:state => :published)
end