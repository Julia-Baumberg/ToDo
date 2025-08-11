class TasksController < ApplicationController
  before_action :require_signin
  before_action :set_task, only: %i[ show edit update destroy ]



  def index
    return @tasks = [] unless current_user

    @priorities = Task::PRIORITY
    filter = params[:priority]

    @tasks =
      if filter == "due_soon"
        current_user.tasks.due_soon(5)
      elsif filter.present?
        current_user.tasks.with_priority(filter)
      else
        current_user.tasks.by_priority
      end
  end

  def show
    @user = @task.user
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
    @task = @user.tasks.find_by(id: params[:id])
  end

  def update
    @task = @user.tasks.find_by(id: params[:id])

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

  private

    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task)
            .permit(:title,
                    :description,
                    :due_date,
                    :priority,
                    :username)
    end
end
