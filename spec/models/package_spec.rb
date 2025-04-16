# frozen_string_literal: true

require "spec_helper"

RSpec.describe Package do
  it "validates the presence of name" do
    package = Package.new(name: nil)
    expect(package.validate).to eq(false)
    expect(package.errors[:name]).to be_present
  end

  it "validates the presence of price_cents" do
    package = Package.new(amount_cents: nil)
    expect(package.validate).to eq(false)
    expect(package.errors[:amount_cents]).to be_present
  end

  it "validates the uniqueness of name scoped to municipality" do
    municipality = Municipality.create(name: "Test Municipality")
    Package.create(name: "Test Package", amount_cents: 1000, municipality: municipality)
    duplicate_package = Package.new(name: "Test Package", amount_cents: 2000, municipality: municipality)
    expect(duplicate_package.validate).to eq(false)
    expect(duplicate_package.errors[:name]).to include("has already been taken")
  end

  it "validates the uniqueness of name across different municipalities" do
    municipality_1 = Municipality.create(name: "Test Municipality 1")
    municipality_2 = Municipality.create(name: "Test Municipality 2")
    Package.create(name: "Test Package", amount_cents: 1000, municipality: municipality_1)
    duplicate_package = Package.new(name: "Test Package", amount_cents: 2000, municipality: municipality_2)
    expect(duplicate_package.validate).to eq(true)
  end

  context "municipality association" do
    let(:municipality) { Municipality.create(name: "Test Municipality") }
    it "belongs to a municipality" do
      package = Package.create(name: "Test Package", amount_cents: 1000, municipality: municipality)

      expect(package.validate).to eq(true)
      expect(package.municipality).to eq(municipality)
    end
  end
end
