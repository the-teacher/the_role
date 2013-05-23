class Page < ActiveRecord::Base
  state_machine :state do
    state :draft, :published, :deleted
  end

  # RELATIONS
  belongs_to :user

  # VALIDATIONS
  validates :user,    presence: true
  validates :title,   presence: true, uniqueness: true
  validates :content, presence: true
end