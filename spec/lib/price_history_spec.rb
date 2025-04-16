# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PriceHistory, type: :model do
  let(:stockholm) { Municipality.create(name: "Stockholm") }
  let(:gothenburg) { Municipality.create(name: "Gothenburg") }
  let(:premium_sthlm) { Package.create!(name: "Premium", amount_cents: 20_00, municipality: stockholm) }
  let(:premium_gbg) { Package.create!(name: "Premium", amount_cents: 20_00, municipality: gothenburg) }
  let(:bas_sthlm) { Package.create!(name: "Farmors köttbullar", amount_cents: 37_00, municipality: sthlm) }
  let(:bas_gbg) { Package.create!(name: "Farmors köttbullar", amount_cents: 37_00, municipality: gothenburg) }

  describe 'call' do
    context 'when municipality has no price history' do
      it 'returns empty price history' do
        price_history = PriceHistory.call(year: 2002, package: premium_sthlm.name, municipality: "MUNICIPALITY NOT EXISTING")
        expect(price_history).to be_empty
      end
    end

    context 'when package has no price history' do
      it 'returns empty price history' do
        price_history = PriceHistory.call(year: 2002, package: "PACKAGE NOT EXISTING", municipality: gothenburg.name)
        expect(price_history).to be_empty
      end
    end

    context 'when package has price history' do
      before do
        price_1 = Price.create!(package: premium_sthlm, amount_cents: 100_00, created_at: Date.new(2023, 4, 1))
        price_2 = Price.create!(package: premium_sthlm, amount_cents: 125_00, created_at: Date.new(2023, 8, 2))
        price_3 = Price.create!(package: premium_sthlm, amount_cents: 175_00, created_at: Date.new(2023, 12, 24))
        price_4 = Price.create!(package: premium_gbg, amount_cents: 25_00, created_at: Date.new(2022, 9, 1))
        price_5 = Price.create!(package: premium_gbg, amount_cents: 50_00, created_at: Date.new(2023, 2, 3))
        price_6 = Price.create!(package: premium_gbg, amount_cents: 75_00, created_at: Date.new(2023, 5, 20))
        price_7 = Price.create!(package: bas_gbg, amount_cents: 100_00, created_at: Date.new(2023, 6, 1))
      end

      context 'when requesting existing price history' do
        it 'returns price history for the package for all municipalities' do
          price_history = PriceHistory.call(year: "2023", package: "Premium")
          expect(price_history).to eq(
            {"Gothenburg"=>[5000, 7500], "Stockholm"=>[10000, 12500, 17500]}
          )
        end

        it 'returns price history for specific municipality' do
          price_history = PriceHistory.call(year: "2023", package: "Premium", municipality: "gothenburg")
          expect(price_history).to eq(
            {"Gothenburg"=>[5000, 7500]}
          )
        end

        it 'returns empty price history for non-existing municipality' do
          price_history = PriceHistory.call(year: "2023", package: "Premium", municipality: "MUNICIPALITY NOT EXISTING")
          expect(price_history).to be_empty
        end

        it 'returns empty price history for non-existing package' do
          price_history = PriceHistory.call(year: "2023", package: "PACKAGE NOT EXISTING")
          expect(price_history).to be_empty
        end

        it 'returns empty for year with no price history' do
          expect(PriceHistory.call(year: "3028", package: "Premium")).to be_empty
        end
      end
    end
  end
end
