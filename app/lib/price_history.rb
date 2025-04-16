# frozen_string_literal: true

class PriceHistory
  def self.call(year:, package:, municipality: nil)
    year_range = Date.new(year.to_i).beginning_of_year..Date.new(year.to_i).end_of_year

    packages = Package.where("LOWER(packages.name) = ?", package.downcase)

    if municipality.present?
      packages = packages.joins(:municipality).where("LOWER(municipalities.name) = ?", municipality.downcase)
    end

    prices = Price.where(package: packages, created_at: year_range)
                  .includes(package: :municipality)
                  .order(:created_at)

    prices.group_by { |price| price.municipality.name }
      .transform_values { |prices| prices.map(&:amount_cents) }
  end
end
