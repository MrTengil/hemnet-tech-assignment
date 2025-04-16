class ChangePackageNameUniquenessConstraint < ActiveRecord::Migration[7.1]
  def change
    remove_index :packages, :name

    add_index :packages, [:name, :municipality_id], unique: true, name: 'index_packages_on_name_and_municipality_id'
  end
end
