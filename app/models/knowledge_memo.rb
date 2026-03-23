class KnowledgeMemo < ApplicationRecord
  belongs_to :disease
  belongs_to :user

  validates :title, presence: true
end
