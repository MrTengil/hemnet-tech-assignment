# frozen_string_literal: true

require "spec_helper"

RSpec.describe Municipality do
  it "validates the presence of name" do
    municipality = Municipality.new(name: nil)
    expect(municipality.validate).to eq(false)
    expect(municipality.errors[:name]).to be_present
  end

  it "validates the uniqueness of name" do
    Municipality.create!(name: "Unique Name")
    municipality = Municipality.new(name: "Unique Name")
    expect(municipality.validate).to eq(false)
    expect(municipality.errors[:name]).to include("has already been taken")
  end
end
