class Page < ActiveRecord::Base
  # RELATIONS
  belongs_to :user

  # VALIDATIONS
  validates :user,    presence: true
  validates :title,   presence: true, uniqueness: true
  validates :content, presence: true

  state_machine :state, :initial => :draft do
    # events
    event :to_draft do 
      transition all => :draft
    end

    event :to_published do
      transition all => :published
    end

    event :to_deleted do
      transition all => :deleted
    end
  end
end