class Video < ApplicationRecord
  include PgSearch::Model

  belongs_to :band
  belongs_to :show
  has_one :venue, through: :show

  pg_search_scope :search,
    against: [:name],
    associated_against: {
      band: :name,
      show: :name,
      venue: :name
    }

  multisearchable against: [:search_keywords], if: :published?

  after_create :check_show_status!

  enum :status, draft: 0, ready: 5, published: 10

  validates :show, :band, :name, :url, presence: true
  validates :url,
    format: {
      with: /\Ahttps:\/\/(?:www.)?youtube.com\/watch\?v=[A-Za-z0-9_\-]+\z/,
      message: "is invalid. Make sure you are using a FULL youtube link: \n\"https://www.youtube.com/watch?v=RKjk0ECXjiQ\""
    }

  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end

  def feature
    Feature.find_by(target_id: id)
  end

  def feature?
    feature.present?
  end

  def display_name
    "#{name} by #{band.name} at #{venue.name}"
  end

  def display_image
    band.image
  end

  def search_keywords
    "#{show.name} #{name} #{band.name} #{venue.name}"
  end

  private

  def check_show_status!
    show.ready! if show.ready_to_publish?
  end
end
