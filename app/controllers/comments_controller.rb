class CommentsController < ApplicationController
  before_action :require_signin, only: %i[ new create edit destroy ]
  before_action :set_task
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :authorize_commenter!, only: %i[new create edit update destroy]

  def index

  end

  def show
  end

  def new
    @comment = @task.comments.new
  end

  def create
    @comment = @task.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to task_path(@task), notice: "Comment added!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @task = Task.find(params[:task_id])
    @comment = @task.comments.find(params[:id])
  end

  def update
    if @comment.update(comment_params)
      redirect_to task_path(@task), notice: "Comment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @task = @comment.task
    @comment.destroy!
    redirect_to task_path(@comment.task), status: :see_other, notice: "Comment was successfully destroyed."
  end

  private

    def set_task
      @task = Task.find(params[:task_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to tasks_path, alert: "Task not found."
    end

    def set_comment
      @comment = @task.comments.find(params[:id])
    end

    def authorize_commenter!
      return if current_user.admin? || @task.user_id == current_user.id
      redirect_to task_path(@task), alert: "You don't have permission to comment on this task."
    end

    def comment_params
      params.require(:comment)
            .permit(:content)
    end

end
