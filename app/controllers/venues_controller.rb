class VenuesController < ApplicationController
  before_action :set_venue, only: [:edit, :update, :destroy]
  before_action :set_venue_scope, only: [:index, :show]
  before_action :require_login, only: [:new, :edit, :create, :update, :destroy]

  def index
    @venues = @scoped_venues.order(created_at: :desc).page(params[:page])
  end

  def show
    @venue  = @scoped_venues.find(params[:id])
    @shows  = @venue.shows.order(date: :desc)
    @videos = @venue.videos.joins(:show, :band).order('shows.date desc, bands.name, videos.name')
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def new
    @venue = Venue.new
  end

  def edit
  end

  def create
    @venue = Venue.new(venue_params)

    if @venue.save
      redirect_to @venue, notice: 'Venue was successfully created.'
    else
      render :new
    end
  end

  def update
    if @venue.update(venue_params)
      redirect_to @venue, notice: 'Venue was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @venue.destroy
    redirect_to venues_url, notice: 'Venue was successfully destroyed.'
  end

  private

  def set_venue
    @venue = Venue.find(params[:id])
  end

  def set_venue_scope
    @scoped_venues = current_user ? Venue.all : Venue.published
    @scoped_venues = @scoped_venues.search(params[:q]) if params[:q]
    @scoped_venues
  end

  def venue_params
    params.require(:venue).permit(
      :name,
      :location,
      :info,
      :website,
      :facebook,
      :instagram,
      :twitter,
      :image,
      :status
    )
  end
end
