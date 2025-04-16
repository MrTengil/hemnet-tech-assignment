# frozen_string_literal: true

class Price < ApplicationRecord
  belongs_to :package, optional: false
  delegate :municipality, to: :package

  validates :amount_cents, presence: true
end
