class TopicsController < ApplicationController
  def index
    @topics = Topic.paginate(:page => params[:page], :per_page => 10)
  end

  def new
    @topic = Topic.new
    authorize! :create, @topic, message: "You need to be an admin to do that."
  end

  def create
    @topic = Topic.new(params[:topic])
    authorize! :create, Topic, "You need to be an admin to create a topic"
    if @topic.save
      flash[:notice] = "Topic was saved"
      redirect_to @topic
    else
      flash[:error] = "There was an error saving the topic, please try again"
      render :new
    end
  end

  def show
    @topic = Topic.find(params["id"])
    @posts = @topic.posts.paginate(page: params[:page], per_page: 10)
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])
    authorize! :update, Topic, "You need to own the topic to update it"
    if @topic.update_attributes(params[:topic])
      redirect_to @topic
    else
      flash[:error] = "There was an error updating the topic. Please try again"
      render :edit
    end
  end
end
