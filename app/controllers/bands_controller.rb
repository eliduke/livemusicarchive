class BandsController < ApplicationController
  before_action :set_band, only: [:show, :edit, :update, :destroy]
  before_action :set_band_scope, only: [:index, :show]
  before_action :require_login, only: [:new, :edit, :create, :update, :destroy]

  def index
    @bands = @scoped_bands.order(created_at: :desc).page(params[:page])
  end

  def show
    @band   = @scoped_bands.find(params[:id])
    @shows  = @band.shows.order(date: :desc)
    @videos = @band.videos.joins(:show).order('shows.date desc, videos.name')
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def new
    @band = Band.new
  end

  def edit
  end

  def create
    @band = Band.new(band_params)

    if @band.save
      redirect_to @band, notice: 'Band was successfully created.'
    else
      render :new
    end
  end

  def update
    if @band.update(band_params)
      redirect_to @band, notice: 'Band was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @band.destroy
    redirect_to bands_url, notice: 'Band was successfully destroyed.'
  end

  private

  def set_band
    @band = Band.find(params[:id])
  end

  def set_band_scope
    @scoped_bands = current_user ? Band.all : Band.published
    @scoped_bands = @scoped_bands.search(params[:q]) if params[:q]
    @scoped_bands
  end

  # Only allow a trusted parameter "white list" through.
  def band_params
    params.require(:band).permit(
      :name,
      :location,
      :bio,
      :website,
      :bandcamp,
      :facebook,
      :soundcloud,
      :instagram,
      :twitter,
      :image,
      :status
    )
  end
end
