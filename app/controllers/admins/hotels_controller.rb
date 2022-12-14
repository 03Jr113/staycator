class Admins::HotelsController < ApplicationController
  
  before_action :authenticate_admin!

  def index
    @hotels = Hotel.all.page(params[:page]).per(7)
  end

  def edit
    @hotel = Hotel.find(params[:id])
    @reviews = @hotel.reviews.page(params[:page]).per(7)
  end

  def update
    @hotel = Hotel.find(params[:id])
    if @hotel.update(hotel_params)
      flash[:notice] = 'ホテル情報を更新しました'
      redirect_to admins_hotels_path
    else
      render :edit
    end
  end

  def destroy
    hotel = Hotel.find(params[:id])
    hotel.destroy
    redirect_to admins_hotels_path
  end

  private

  def hotel_params
    params.require(:hotel).permit(:hotel_name, :area)
  end

end
