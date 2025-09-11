class FeaturesController < ApplicationController
  before_action :set_feature, only: [:edit, :update]
  before_action :set_video, only: [:set, :edit]
  before_action :require_login, only: [:edit, :update]

  def set
  end

  def edit
    @feature.caption = nil if referred_from_set?
  end

  def update
    if @feature.update(feature_params)
      redirect_to admin_path, notice: 'Feature was successfully changed.'
    else
      render :edit
    end
  end

  private

  def set_feature
    @feature = Feature.find(params[:id])
  end

  def set_video
    @video = Video.find(params[:video_id])
  end

  def referred_from_set?
    Rails.application.routes.recognize_path(request.referrer)[:action] == 'set'
  end

  def feature_params
    params.require(:feature).permit(:target_id, :caption)
  end
end
