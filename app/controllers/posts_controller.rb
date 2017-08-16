class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]

  def index
    @posts = Post.all.sort_by { |post| post.total_votes }.reverse
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.sort_by { |comment| comment.total_votes}.reverse
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

  def vote
    vote = Vote.create(vote: params[:vote], voteable: @post, creator: current_user)

    if vote.valid?
      flash[:notice] = "Your vote counted successfully!"
    else
      flash[:error] = "You can only vote on #{@post.title} once!"
    end

    redirect_to :back
  end

  private

  def post_params
    params.require(:post).permit!
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
