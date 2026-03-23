class KnowledgeMemo < ApplicationRecord
  belongs_to :disease
  belongs_to :user

  validates :title, presence: true

  scope :owned_by, ->(user) { where(user: user) }
end
