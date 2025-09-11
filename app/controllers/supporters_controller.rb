class SupportersController < ApplicationController
  before_action :require_login
  before_action :set_supporter, only: [:update, :destroy]

  def create
    @supporter = Supporter.new(supporter_params)

    if @supporter.save
      redirect_to admin_url, notice: "#{@supporter.name} was added to the Supporters list!"
    else
      render :new
    end
  end

  def update
    if @supporter.update(supporter_params)
      redirect_to admin_url, notice: "#{@supporter.name} was updated on the Supporters list."
    else
      render :edit
    end
  end

  def destroy
    @supporter.destroy
    redirect_to admin_url, notice: "#{@supporter.name} was removed from the Supporters list."
  end

  private

  def set_supporter
    @supporter = Supporter.find(params[:id])
  end

  def supporter_params
    params.require(:supporter).permit(:name)
  end
end
