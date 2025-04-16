# frozen_string_literal: true

class Package < ApplicationRecord
  belongs_to :municipality, optional: true
  has_many :prices, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :municipality_id }
  validates :amount_cents, presence: true
end
