class HomeController < ApplicationController
  def index
    return @tasks = [] unless current_user

    @tasks_count = current_user.tasks.count
    @completed_count = current_user.tasks.is_completed.count
    @open_count = current_user.tasks.not_completed.count
  end
end
