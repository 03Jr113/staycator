class Users::UsersController < ApplicationController

  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update]
  before_action :ensure_guest_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @reviews = @user.reviews.page(params[:page]).per(3)
    @followed_users = @user.followed_user.page(params[:page]).per(5)
    @follower_users = @user.follower_user.page(params[:page]).per(5)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = 'プロフィールを更新しました'
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  def unsubscribe
    @user = current_user
  end

  def withdraw
    @user = current_user
    @user.update(is_deleted: true)
    reset_session
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:image, :name, :introduction, :age, :gender, :area, :email, :is_deleted)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to user_path(current_user) unless @user == current_user
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "Guest_User"
      flash[:alert] = "ゲストユーザではご利用いただけません"
      redirect_to root_path
    end
  end

end
