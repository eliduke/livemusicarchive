class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy]
  before_action :set_video_scope, only: [:index, :show]
  before_action :require_login, only: [:new, :edit, :create, :update, :destroy]

  def index
    @videos = @scoped_videos.order(created_at: :desc)

    # URL Parameter Filters
    @videos = @videos.where(band_id: params[:band_id]) if params[:band_id]
    @videos = @videos.where(show_id: params[:show_id]) if params[:show_id]
    @videos = @videos.joins(:show).where(shows: { venue_id: params[:venue_id]}) if params[:venue_id]

    @videos = @videos.page(params[:page])

    @hide_band = params[:band_id].present?
    @hide_venue = params[:venue_id].present? || params[:show_id].present?
  end

  def show
    @video = @scoped_videos.find(params[:id])
    @videos = @video.band.videos - [@video]
    @shows = @video.band.shows.order(date: :desc) - [@video.show]
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def new
    @video = Video.new
  end

  def edit
  end

  def create
    @video = Video.new(video_params)

    if @video.save
      redirect_to @video.show, notice: 'Video was added successfully!'
    else
      render :new
    end
  end

  def update
    if @video.update(video_params)
      redirect_to @video, notice: 'Video was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @video.destroy
    redirect_to videos_url, notice: 'Video was successfully destroyed.'
  end

  private

  def set_video
    @video = Video.find(params[:id])
  end

  def set_video_scope
    @scoped_videos ||= current_user ? Video.all : Video.published
    @scoped_videos = @scoped_videos.search(params[:q]) if params[:q]
    @scoped_videos
  end

  def video_params
    params.require(:video).permit(
      :band_id,
      :show_id,
      :name,
      :url,
      :status
    )
  end
end
