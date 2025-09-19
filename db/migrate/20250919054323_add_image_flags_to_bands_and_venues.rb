class AddImageFlagsToBandsAndVenues < ActiveRecord::Migration[8.0]
  def change
    add_column :bands, :image_attached, :boolean, null: false, default: false
    add_column :venues, :image_attached, :boolean, null: false, default: false
  end
end
