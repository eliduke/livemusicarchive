namespace :active_storage do
  desc "Copies `object.image.attached?` into `image_attached` for all bands and venues"
  task image_attached_backup: :environment do
    Band.all.each do |band|
      band.update_attribute(:image_attached, band.image.attached? )
    end

    Venue.all.each do |venue|
      venue.update_attribute(:image_attached, venue.image.attached? )
    end
  end
end
