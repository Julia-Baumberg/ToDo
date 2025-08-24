class TasksController < ApplicationController
  before_action :require_signin
  before_action :set_task, only: %i[ show edit update destroy mark_completed]



  def index
    return @tasks = [] unless current_user

    @priorities = Task::PRIORITY
    filter = params[:priority]

    @tasks = if filter == "due_soon"
        current_user.tasks.not_completed.due_soon(5)
      elsif filter.present?
        current_user.tasks.not_completed.with_priority(filter)
      else
        current_user.tasks.not_completed.by_due_date
      end

    @completed_tasks = if filter == "due_soon"
      current_user.tasks.is_completed.due_soon(5)
    elsif filter.present?
      current_user.tasks.is_completed.with_priority(filter)
    else
      current_user.tasks.is_completed.by_due_date
    end
  end

  def show
    @comments = @task.comments.includes(:user).order(created_at: :desc)
  end

  def new
    @task = Task.new
  end

  def create
    # @user = User.find(session[:user_id])
    @task = current_user.tasks.new(task_params)

      if @task.save
        redirect_to task_path(@task), notice: "Task was successfully created."
      else
        flash.now[:danger] = "I'm sorry, Dave, I'm afraid I can't do that.."
        render :new, status: :unprocessable_entity
      end
  end

  def edit
  end

  def update
      if @task.update(task_params)
        redirect_to task_path, notice: "Task was successfully updated."
      else
        flash.now[:danger] = "I'm sorry, Dave, I'm afraid I can't do that.."
        render :edit, status: :unprocessable_entity
      end
  end


  def destroy
    @task.destroy!
    redirect_to tasks_path, status: :see_other, notice: "Task was successfully destroyed."
  end

  def all_tasks
    redirect_to(tasks_path, notice: "You are not authorized to access this page.") and return unless current_user_admin?

    @tasks = Task.all

    @tasks = @tasks.joins(:user).where(users: { username: params[:username] }) if params[:username].present?

    @tasks = @tasks.where(is_completed: [true, false])

    @open_tasks = @tasks.not_completed.order(due_date: :asc)
    @completed_tasks = @tasks.is_completed.order(due_date: :asc)

    @users = User.order(:username)
  end


  def mark_completed
    if @task.update(is_completed: !@task.is_completed)
      message = @task.is_completed ? "Task marked as completed." : "Task marked as not completed."
      redirect_to request.referer || tasks_path, notice: message
    else
      redirect_to request.referer || tasks_path, alert: "Unable to update task."
    end
  end

  private

    def set_task
      if current_user_admin?
        @task = Task.find(params[:id])
      else
        @task = current_user.tasks.find(params[:id])
      end
    end

    def task_params
      params.require(:task)
            .permit(:title,
                    :description,
                    :due_date,
                    :priority)
    end
end
