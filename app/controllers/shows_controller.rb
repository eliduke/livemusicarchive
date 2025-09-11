class ShowsController < ApplicationController
  before_action :set_show, only: [:show, :edit, :update, :publish, :destroy]
  before_action :set_show_scope, only: [:index, :show]
  before_action :require_login, only: [:new, :edit, :create, :update, :publish, :destroy]

  def index
    @shows = @scoped_shows.order(date: :desc)

    # URL Parameter Filters
    @shows = @shows.where(venue_id: params[:venue_id]) if params[:venue_id]
    @shows = @shows.where(band_id: params[:band_id]) if params[:band_id]

    @shows = @shows.page(params[:page])
  end

  def show
    @show  = @scoped_shows.find(params[:id])
    @bands = @show.bands.order(:name)
    @videos = @show.videos.order(:name)

    if @bands.size < 3
      @flex_container_adjustment = "style=\"justify-content: flex-start\"".html_safe
      @flex_item_adjustment = "style=\"margin-right: 20px\"".html_safe
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def new
    @show = Show.new
  end

  def edit
  end

  def create
    @show = Show.new(show_params)

    if @show.save
      redirect_to @show, notice: 'Show was successfully created.'
    else
      render :new
    end
  end

  def update
    if @show.update(show_params)
      redirect_to @show, notice: 'Show was successfully updated.'
    else
      render :edit
    end
  end

  def publish
    PublishShow.call(@show)
    redirect_back(fallback_location: admin_path)
  end

  def destroy
    @show.destroy
    redirect_to shows_url, notice: 'Show was successfully destroyed.'
  end

  private

  def set_show
    @show = Show.find(params[:id])
  end

  def set_show_scope
    @scoped_shows = current_user ? Show.all : Show.published
    @scoped_shows = @scoped_shows.search(params[:q]) if params[:q]
    @scoped_shows
  end

  def show_params
    params.require(:show).permit(
      :name,
      :date,
      :notes,
      :venue_id,
      :status,
      band_ids: []
    )
  end
end
