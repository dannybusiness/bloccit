class CommentsController < ApplicationController
  def new
  	@comment = Comment.new
  end

  def create
  	@topic = Topic.find(params[:topic_id])
  	@post = Post.find(params[:post_id])
  	@comment = Comment.new(params[:comment])
  	@comment.post = @post

  	if @comment.save
      flash[:notice] = "Comment was saved."
      redirect_to [@topic, @post] 
    else
      flash[:error] = "There was an error saving the Comment. Please try again."
      render :new
    end
  end

  def destroy
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])

    @comment = @post.comment.find(params[:id])

    authorize! :destroy, @comment, message: "You need to own the comment to delete it"
    if @comment.destroy
      flash[:notice] = "Comment was removed"
      redirect_to [@topic, @post]
    else
      flash[:error] = "There was an error deleting the comment"
      redirect_to [@topic, @post]
  end

end
