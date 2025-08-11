class CommentsController < ApplicationController
  before_action :require_signin, only: %i[ edit ]
  before_action :set_task

  def index

  end

  def show

  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = @task.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @task, notice: "Comment added!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit

  end

  def update

  end

  def destroy

  end

  private

    def set_task
      @task = current_user.tasks.find(params[:task_id])
    end

    def comment_params
      params.require(:comment)
            .permit(:body)
    end

end
