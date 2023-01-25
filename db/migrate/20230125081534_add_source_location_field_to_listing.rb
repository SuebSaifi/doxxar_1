class AddSourceLocationFieldToListing < ActiveRecord::Migration[5.2]
  def change
    add_column :listings, :source_country, :string, after: :destination
    add_column :listings, :source_city, :string, after: :source_country
  end
end
