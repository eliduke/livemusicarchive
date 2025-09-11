class Feature < ApplicationRecord
  validates :name, :target_id, presence: true
  validates :target_id, uniqueness: true

  SLOTS = %w(video-1 video-2 video-3 video-4)

  def video
    Video.find(target_id)
  end
end
