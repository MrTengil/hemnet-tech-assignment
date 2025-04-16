# frozen_string_literal: true

require "spec_helper"

RSpec.describe Price do
  it "validates the presence of price_cents" do
    price = Price.new
    expect(price.validate).to eq(false)
    expect(price.errors[:amount_cents]).to be_present
  end

  it "validates the presence of package" do
    price = Price.new
    expect(price.validate).to eq(false)
    expect(price.errors[:package]).to be_present
  end

  it "delegates municipality to package" do
    municipality = Municipality.create(name: "Testland")
    package = Package.create(name: "Stekjärn", amount_cents: 100_00, municipality: municipality)
    price = Price.create(amount_cents: package.amount_cents, package: package)

    expect(price.municipality).to eq(municipality)
  end
end
