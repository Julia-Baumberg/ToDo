class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :require_signin, except: %i[new create]
  before_action :require_correct_user_or_admin, only: %i[edit update destroy]

  def index
    unless current_user&.admin?
      flash[:notice] = "You don't have access to that page!"
      redirect_to tasks_path
      return
    end

    @users = User.all
    @task = Task.find_by(id: params[:task_id])
  end

  def show
    @tasks = @user.tasks
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      if current_user.nil?
        session[:user_id] = @user.id
      end
      redirect_to user_path(@user), notice: "User successfully created."
    else
      flash.now[:danger] = "I'm sorry, Dave, I'm afraid I can't do that.."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
      if @user.update(user_params)
        redirect_to @user, notice: "User was successfully updated."
      else
        flash.now[:danger] = "I'm sorry, Dave, I'm afraid I can't do that.."
        render :edit, status: :unprocessable_entity
      end
  end

  def destroy
    if current_user == @user && !current_user.admin?
      @user.destroy
      session[:user_id] = nil
      redirect_to home_path, status: :see_other, alert: 'Account successfully deleted!'
    elsif current_user.admin?
      @user.destroy
      redirect_to users_path, status: :see_other, notice: 'User successfully deleted by admin.'
    else
      redirect_to home_path, alert: 'Not authorized to perform this action.'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user)
          .permit(:first_name,
                  :last_name,
                  :username,
                  :email,
                  :password,
                  :password_confirmation)
  end

  def require_correct_user_or_admin
    unless current_user == @user || current_user.admin?
      redirect_to home_path, alert: "Not authorized!"
    end
  end
end
