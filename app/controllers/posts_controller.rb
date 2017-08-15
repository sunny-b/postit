class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update]
  before_action :require_user, except: [:index, :show]

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def new
    @post = Post.new
    @categories = Category.all
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user

    if @post.save
      flash[:notice] = "Post was successfully created!"
      redirect_to posts_path
    else
      render 'new'
    end
  end

  def update
    if @post.update(post_params)
      flash[:notice] = "Post was successfully updated"
      redirect_to posts_path
    else
      render 'edit'
    end
  end

  def edit; end

  private

  def post_params
    params.require(:post).permit!
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
