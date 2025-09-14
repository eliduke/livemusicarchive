class HomeController < ApplicationController
  before_action :require_login, only: [:admin]

  def index
    @main_feature = Feature.find_by(name: 'video-1')
    @main_video = @main_feature.video
    @other_features = Feature.where(name: ['video-2', 'video-3', 'video-4'])
    @recent_shows = Show.order(created_at: :desc).limit(3)
    @recent_bands = Band.order(created_at: :desc).limit(3)
    @recent_videos = Video.order(created_at: :desc).limit(3)
    @supporters = Supporter.all.order(:name).pluck(:name)
  end

  def admin
    @main_feature = Feature.find_by(name: 'video-1')
    @other_features = Feature.where(name: ['video-2', 'video-3', 'video-4'])
    @ready_to_publish_shows = Show.ready
    @shows_in_draft = Show.draft.order(:created_at).limit(10)

    @supporters = Supporter.all.order(:name)

    if params[:supporter_id].present?
      @supporter = Supporter.find(params[:supporter_id])
      @supporter_name_label = "Edit Supporter - #{helpers.link_to 'Cancel', admin_path}".html_safe
    else
      @supporter = Supporter.new
      @supporter_name_label = "Add New Supporter"
    end
  end
end
