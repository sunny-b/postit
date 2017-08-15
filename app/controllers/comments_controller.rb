class CommentsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(params.require(:comment).permit(:body))
    @comment.creator = current_user
    
    binding.pry
    if @comment.save
      flash[:notice] = 'Your comment was added successfully'
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end
end