class CommentsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.find_by(slug: params[:post_id])
    @comments = @post.comments.sort_by { |comment| comment.total_votes }.reverse
    @comment = @post.comments.build(params.require(:comment).permit(:body))
    @comment.creator = current_user
    
    if @comment.save
      flash[:notice] = 'Your comment was added successfully'
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end

  def vote
    @comment = Comment.find(params[:id])
    vote = Vote.create(vote: params[:vote], creator: current_user, voteable: @comment)

    respond_to do |format|
      format.html do
        if vote.valid?
          flash[:notice] = "Your vote counted successfully!"
        else
          flash[:error] = "You can only vote for this comment once!"
        end

        redirect_to :back
      end
      
      format.js do
        unless vote.valid?
          flash.now[:error] = true
        end
      end
    end
  end
end