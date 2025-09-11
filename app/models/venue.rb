class Venue < ApplicationRecord
  include PgSearch::Model

  pg_search_scope :search, against: :name
  multisearchable against: [:search_keywords], if: :published?

  has_many :shows
  has_many :videos, through: :shows
  has_one_attached :image

  enum :status, draft: 0, ready: 5, published: 10

  validates :name, presence: true

  validates :website, :facebook, :instagram, :twitter,
    format: {
      with: /\A(http|https):\/\/[\S]+\.[\S]+\z/,
      message: "is invalid. Make sure you include 'http://' or 'https://' at the beginning.",
      allow_blank: true
    }

  def self.rebuild_pg_search_documents
    find_each { |record| record.update_pg_search_document }
  end

  def display_name
    name
  end

  def display_image
    image
  end

  def search_keywords
    "#{name} #{info}"
  end
end
