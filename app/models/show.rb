class Show < ApplicationRecord
  include PgSearch::Model

  belongs_to :venue
  has_many :videos
  has_and_belongs_to_many :bands

  pg_search_scope :search,
    against: [:name, :notes],
    associated_against: {
      bands: :name,
      venue: :name
    }

  multisearchable against: [:search_keywords], if: :published?

  validates :venue, :bands, presence: true

  enum :status, draft: 0, ready: 5, published: 10

  def self.options_for_select
    options = []

    all.each do |show|
      options << ["#{show.display_name} at #{show.venue.name}", show.id]
    end

    options
  end

  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end

  def display_name
    name? ? name : bands.map(&:name).sort.join(", ")
  end

  def display_image
    venue.image
  end

  # do all of the bands in the show all have at least one video
  def ready_to_publish?
    bands.pluck(:id).sort == videos.pluck(:band_id).uniq.sort
  end

  def search_keywords
    "#{name} #{bands.map(&:name).sort.join(" ")} #{venue.name}"
  end
end
