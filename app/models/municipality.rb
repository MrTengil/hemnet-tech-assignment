class Municipality < ApplicationRecord
  has_many :packages, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
