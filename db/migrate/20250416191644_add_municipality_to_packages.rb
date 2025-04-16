class AddMunicipalityToPackages < ActiveRecord::Migration[7.1]
  def change
    add_reference :packages, :municipality, null: true, foreign_key: true
  end
end
