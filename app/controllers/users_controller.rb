class UsersController < ApplicationController
  before_action :set_user, except: [:new, :create]
  before_action :require_same_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "Your user was created successfully!"
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render 'new'
    end
  end

  def show
    @posts = @user.posts.sort_by { |post| post.total_votes}.reverse
    @comments = @user.comments.sort_by { |comment| comment.total_votes}.reverse
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'You updated your profile successfully!'
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :time_zone)
  end

  def set_user
    @user = User.find_by(slug: params[:id])
  end

  def require_same_user
    unless @user == current_user
      flash[:error] = "You do not have access to this page!"
      redirect_to root_path
    end
  end
end