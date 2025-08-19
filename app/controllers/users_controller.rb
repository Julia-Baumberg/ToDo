class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :require_signin, except: %i[new create]
  before_action :require_correct_user_or_admin, only: %i[edit update destroy]

  # GET /users or /users.json
  def index
    unless current_user&.admin?
      flash[:notice] = "You don't have access to that page!"
      redirect_to tasks_path
      return
    end

    @users = User.all
    @task = Task.find_by(id: params[:task_id])
  end

  # GET /users/1 or /users/1.json
  def show
    @tasks = @user.tasks
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id
        redirect_to user_path(@user), notice: "User successfully created."
      else
        flash.now[:danger] = "I'm sorry, Dave, I'm afraid I can't do that.."
        render :new, status: :unprocessable_entity
      end
  end

  # GET /users/1/edit
  def edit; end

  # PATCH/PUT /users/1 or /users/1.json
  def update
      if @user.update(user_params)
        redirect_to @user, notice: "User was successfully updated."
      else
        flash.now[:danger] = "I'm sorry, Dave, I'm afraid I can't do that.."
        render :edit, status: :unprocessable_entity
      end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    session[:user_id] = nil if current_user == @user
    redirect_to root_path, status: :see_other, alert: 'Account successfully deleted!'
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
      redirect_to root_path, alert: "Not authorized!"
    end
  end
end
